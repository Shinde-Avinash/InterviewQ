/**
 * TestService — manages test creation, execution, scoring with negative marking.
 */
component singleton accessors="true" {

    /**
     * Get all available tests
     */
    function getAvailableTests( boolean isPractice = false ) {
        return queryExecute(
            "SELECT t.id, t.title, t.description, t.category_id, t.difficulty_id, t.is_active, t.is_practice, t.created_at,
                    c.name as category_name, c.icon as category_icon, c.color as category_color,
                    d.name as difficulty_name, d.color as difficulty_color,
                    (SELECT COUNT(*) FROM questions WHERE category_id = t.category_id AND is_active = 1) as total_questions
             FROM tests t
             LEFT JOIN categories c ON t.category_id = c.id
             LEFT JOIN difficulty_levels d ON t.difficulty_id = d.id
             WHERE t.is_active = 1 AND t.is_practice = :isPractice
             ORDER BY t.created_at DESC",
            { isPractice: arguments.isPractice ? 1 : 0 },
            { datasource: "stddb" }
        );
    }

    /**
     * Get test by ID
     */
    function getTestById( required numeric testId ) {
        return queryExecute(
            "SELECT t.id, t.title, t.description, t.category_id, t.difficulty_id, t.is_active, t.is_practice,
                    c.name as category_name, d.name as difficulty_name,
                    (SELECT COUNT(*) FROM questions WHERE category_id = t.category_id AND is_active = 1) as total_questions
             FROM tests t
             LEFT JOIN categories c ON t.category_id = c.id
             LEFT JOIN difficulty_levels d ON t.difficulty_id = d.id
             WHERE t.id = :id",
            { id: arguments.testId },
            { datasource: "stddb" }
        );
    }

    /**
     * Start a test attempt — picks random questions and creates the attempt
     */
    function startTest( required numeric testId, required numeric userId ) {
        var test = getTestById( arguments.testId );
        if ( !test.recordCount ) {
            return { "success": false, "message": "Test not found." };
        }

        // Pull ALL active questions (ignoring difficulty for dynamic scale)
        var catFilter = test.category_id != "" ? test.category_id : 0;
        var sql = "SELECT id FROM questions WHERE is_active = 1";
        var params = {};
        if ( val(catFilter) > 0 ) {
            sql &= " AND category_id = :catId";
            params.catId = catFilter;
        }
        sql &= " ORDER BY RAND() LIMIT 1000"; 
        
        var questions = queryExecute( sql, params, { datasource: "stddb" } );
        var actualCount = questions.recordCount;
        var dynamicDuration = ceiling( actualCount * 1.5 );

        // Check for existing in-progress attempt
        var existing = queryExecute(
            "SELECT id, total_marks FROM test_attempts WHERE test_id = :testId AND user_id = :userId AND status = 'in_progress'",
            { testId: arguments.testId, userId: arguments.userId },
            { datasource: "stddb" }
        );
        
        // ONLY resume if the question count (total_marks) is the same. 
        // If question count changed, we start a fresh mission for the latest data.
        if ( existing.recordCount AND existing.total_marks == actualCount ) {
            return { "success": true, "attemptId": existing.id, "resumed": true };
        } else if ( existing.recordCount ) {
            // Mark the stale attempt as abandoned so it doesn't block future checks
            queryExecute(
                "UPDATE test_attempts SET status = 'abandoned' WHERE id = :id",
                { id: existing.id },
                { datasource: "stddb" }
            );
        }

        // Create attempt with ACTUAL question count and dynamic duration (with fallback for missing column)
        try {
            queryExecute(
                "INSERT INTO test_attempts (test_id, user_id, started_at, total_marks, duration_minutes)
                 VALUES (:testId, :userId, NOW(), :totalMarks, :duration)",
                {
                    testId:     arguments.testId,
                    userId:     arguments.userId,
                    totalMarks: actualCount,
                    duration:   dynamicDuration
                },
                { datasource: "stddb" }
            );
        } catch ( any e ) {
            queryExecute(
                "INSERT INTO test_attempts (test_id, user_id, started_at, total_marks)
                 VALUES (:testId, :userId, NOW(), :totalMarks)",
                {
                    testId:     arguments.testId,
                    userId:     arguments.userId,
                    totalMarks: actualCount
                },
                { datasource: "stddb" }
            );
        }

        var attemptResult = queryExecute( "SELECT LAST_INSERT_ID() as id", {}, { datasource: "stddb" } );
        var attemptId = attemptResult.id;

        // Create answer slots
        for ( var q in questions ) {
            queryExecute(
                "INSERT INTO attempt_answers (attempt_id, question_id) VALUES (:attemptId, :questionId)",
                { attemptId: attemptId, questionId: q.id },
                { datasource: "stddb" }
            );
        }

        return { "success": true, "attemptId": attemptId, "resumed": false };
    }

    /**
     * Get questions for an active attempt
     */
    function getAttemptQuestions( required numeric attemptId ) {
        return queryExecute(
            "SELECT aa.id as answer_id, aa.selected_option_id, aa.is_bookmarked,
                    q.id as question_id, q.question_text, q.code_snippet, q.category_id,
                    c.name as category_name
             FROM attempt_answers aa
             JOIN questions q ON aa.question_id = q.id
             JOIN categories c ON q.category_id = c.id
             WHERE aa.attempt_id = :attemptId
             ORDER BY aa.id",
            { attemptId: arguments.attemptId },
            { datasource: "stddb" }
        );
    }

    /**
     * Get options for a question
     */
    function getQuestionOptions( required numeric questionId ) {
        return queryExecute(
            "SELECT * FROM question_options WHERE question_id = :id ORDER BY sort_order",
            { id: arguments.questionId },
            { datasource: "stddb" }
        );
    }

    /**
     * Save an answer
     */
    function saveAnswer( required numeric attemptId, required numeric questionId,
                          required numeric selectedOptionId ) {
        // Check if the selected option is correct
        var optionCheck = queryExecute(
            "SELECT is_correct FROM question_options WHERE id = :optionId",
            { optionId: arguments.selectedOptionId },
            { datasource: "stddb" }
        );
        var isCorrect = optionCheck.recordCount && optionCheck.is_correct ? 1 : 0;

        queryExecute(
            "UPDATE attempt_answers
             SET selected_option_id = :optionId, is_correct = :isCorrect
             WHERE attempt_id = :attemptId AND question_id = :questionId",
            {
                optionId:   arguments.selectedOptionId,
                isCorrect:  isCorrect,
                attemptId:  arguments.attemptId,
                questionId: arguments.questionId
            },
            { datasource: "stddb" }
        );
        return { "success": true, "isCorrect": isCorrect };
    }

    /**
     * Toggle bookmark
     */
    function toggleBookmark( required numeric attemptId, required numeric questionId ) {
        queryExecute(
            "UPDATE attempt_answers SET is_bookmarked = NOT is_bookmarked
             WHERE attempt_id = :attemptId AND question_id = :questionId",
            { attemptId: arguments.attemptId, questionId: arguments.questionId },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Submit a test — calculate scores
     */
    function submitTest( required numeric attemptId ) {
        // Get attempt info
        var attempt = queryExecute(
            "SELECT ta.*, t.negative_marking, t.negative_mark_value, t.total_questions
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             WHERE ta.id = :id",
            { id: arguments.attemptId },
            { datasource: "stddb" }
        );

        if ( !attempt.recordCount ) {
            return { "success": false, "message": "Attempt not found." };
        }

        // Calculate score
        var answers = queryExecute(
            "SELECT selected_option_id, is_correct FROM attempt_answers WHERE attempt_id = :id",
            { id: arguments.attemptId },
            { datasource: "stddb" }
        );

        var correct = 0;
        var wrong = 0;
        var unanswered = 0;
        var score = 0;

        for ( var ans in answers ) {
            if ( ans.selected_option_id == "" || ans.selected_option_id == 0 ) {
                unanswered++;
            } else if ( ans.is_correct == 1 ) {
                correct++;
                score += 1;
            } else {
                wrong++;
                if ( attempt.negative_marking ) {
                    score -= attempt.negative_mark_value;
                }
            }
        }

        var totalMarks = answers.recordCount;
        var percentage = totalMarks > 0 ? ( score / totalMarks ) * 100 : 0;
        if ( percentage < 0 ) percentage = 0;

        // Update attempt
        queryExecute(
            "UPDATE test_attempts
             SET finished_at = NOW(), score = :score, total_marks = :totalMarks,
                 percentage = :percentage, correct_answers = :correct,
                 wrong_answers = :wrong, unanswered = :unanswered,
                 status = 'completed',
                 time_taken_seconds = TIMESTAMPDIFF(SECOND, started_at, NOW())
             WHERE id = :id",
            {
                id:         arguments.attemptId,
                score:      score,
                totalMarks: totalMarks,
                percentage: percentage,
                correct:    correct,
                wrong:      wrong,
                unanswered: unanswered
            },
            { datasource: "stddb" }
        );

        // Update leaderboard
        var userId = attempt.user_id;
        queryExecute(
            "INSERT INTO leaderboard (user_id, total_score, tests_taken, avg_percentage, best_score)
             VALUES (:userId, :score, 1, :percentage, :percentage)
             ON DUPLICATE KEY UPDATE
                total_score = total_score + :score,
                tests_taken = tests_taken + 1,
                avg_percentage = (avg_percentage * (tests_taken - 1) + :percentage) / tests_taken,
                best_score = GREATEST(best_score, :percentage)",
            { userId: userId, score: score, percentage: percentage },
            { datasource: "stddb" }
        );

        return {
            "success":    true,
            "score":      score,
            "totalMarks": totalMarks,
            "percentage": percentage,
            "correct":    correct,
            "wrong":      wrong,
            "unanswered": unanswered
        };
    }

    /**
     * Get user's test history
     */
    function getTestHistory( required numeric userId, numeric limit = 10 ) {
        return queryExecute(
            "SELECT ta.*, t.title as test_title, t.total_questions,
                    c.name as category_name, c.icon as category_icon
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             LEFT JOIN categories c ON t.category_id = c.id
             WHERE ta.user_id = :userId AND ta.status = 'completed'
             ORDER BY ta.finished_at DESC
             LIMIT :lim",
            { userId: arguments.userId, lim: arguments.limit },
            { datasource: "stddb" }
        );
    }

    /**
     * Create a new test
     */
    function createTest(
        required string title,
        required string description,
        required numeric categoryId,
        required numeric difficultyId,
        required numeric totalQuestions,
        required numeric timeMinutes,
        required boolean isPractice,
        required boolean negativeMarking,
        required numeric negativeMarkValue
    ) {
        queryExecute(
            "INSERT INTO tests (title, description, category_id, difficulty_id, total_questions, time_minutes, is_practice, negative_marking, negative_mark_value, created_at)
             VALUES (:title, :desc, :catId, :diffId, :questions, :time, :practice, :neg, :negVal, NOW())",
            {
                title:     arguments.title,
                desc:      arguments.description,
                catId:     arguments.categoryId,
                diffId:    arguments.difficultyId,
                questions: arguments.totalQuestions,
                time:      arguments.timeMinutes,
                practice:  arguments.isPractice ? 1 : 0,
                neg:       arguments.negativeMarking ? 1 : 0,
                negVal:    arguments.negativeMarkValue
            },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Update an existing test
     */
    function updateTest(
        required numeric testId,
        required string title,
        required string description,
        required numeric categoryId,
        required numeric difficultyId,
        required numeric totalQuestions,
        required numeric timeMinutes,
        required boolean isPractice,
        required boolean negativeMarking,
        required numeric negativeMarkValue,
        required boolean isActive
    ) {
        queryExecute(
            "UPDATE tests
             SET title = :title, description = :desc, category_id = :catId, difficulty_id = :diffId,
                 total_questions = :questions, time_minutes = :time, is_practice = :practice,
                 negative_marking = :neg, negative_mark_value = :negVal, is_active = :status
             WHERE id = :id",
            {
                id:        arguments.testId,
                title:     arguments.title,
                desc:      arguments.description,
                catId:     arguments.categoryId,
                diffId:    arguments.difficultyId,
                questions: arguments.totalQuestions,
                time:      arguments.timeMinutes,
                practice:  arguments.isPractice ? 1 : 0,
                neg:       arguments.negativeMarking ? 1 : 0,
                negVal:    arguments.negativeMarkValue,
                status:    arguments.isActive ? 1 : 0
            },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Delete a test
     */
    function deleteTest( required numeric testId ) {
        // We might want to check for attempts first or just soft delete
        queryExecute( "UPDATE tests SET is_active = 0 WHERE id = :id", { id: arguments.testId }, { datasource: "stddb" } );
        return { "success": true };
    }

    /**
     * Get test count
     */
    function getTestCount() {
        var result = queryExecute( "SELECT COUNT(*) as cnt FROM tests WHERE is_active = 1", {}, { datasource: "stddb" } );
        return result.cnt;
    }

}

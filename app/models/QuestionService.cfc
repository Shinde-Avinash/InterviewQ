/**
 * QuestionService — CRUD, random generation, filtering, and bulk import for questions.
 */
component singleton accessors="true" {

    /**
     * Get questions with pagination and filters
     */
    function getQuestions( numeric page = 1, numeric pageSize = 20,
                           numeric categoryId = 0, numeric difficultyId = 0,
                           string search = "" ) {

        var sql = "SELECT q.*, c.name as category_name, d.name as difficulty_name, d.color as difficulty_color,
                          (SELECT COUNT(*) FROM question_options WHERE question_id = q.id) as option_count
                   FROM questions q
                   JOIN categories c ON q.category_id = c.id
                   JOIN difficulty_levels d ON q.difficulty_id = d.id
                   WHERE 1=1";
        var countSql = "SELECT COUNT(*) as total FROM questions q WHERE 1=1";
        var params = {};

        if ( arguments.categoryId > 0 ) {
            sql &= " AND q.category_id = :categoryId";
            countSql &= " AND q.category_id = :categoryId";
            params.categoryId = arguments.categoryId;
        }
        if ( arguments.difficultyId > 0 ) {
            sql &= " AND q.difficulty_id = :difficultyId";
            countSql &= " AND q.difficulty_id = :difficultyId";
            params.difficultyId = arguments.difficultyId;
        }
        if ( len(arguments.search) ) {
            sql &= " AND q.question_text LIKE :search";
            countSql &= " AND q.question_text LIKE :search";
            params.search = "%" & arguments.search & "%";
        }

        // Get total count
        var totalResult = queryExecute( countSql, params, { datasource: "stddb" } );
        var total = totalResult.total;

        // Paginate
        var offset = ( arguments.page - 1 ) * arguments.pageSize;
        sql &= " ORDER BY q.created_at DESC LIMIT :limit OFFSET :offset";
        params.limit  = arguments.pageSize;
        params.offset = offset;

        var questions = queryExecute( sql, params, { datasource: "stddb" } );

        return {
            "questions":  questions,
            "total":      total,
            "page":       arguments.page,
            "pageSize":   arguments.pageSize,
            "totalPages": ceiling( total / arguments.pageSize )
        };
    }

    /**
     * Get a single question by ID with its options
     */
    function getQuestionById( required numeric questionId ) {
        var question = queryExecute(
            "SELECT q.*, c.name as category_name, d.name as difficulty_name
             FROM questions q
             JOIN categories c ON q.category_id = c.id
             JOIN difficulty_levels d ON q.difficulty_id = d.id
             WHERE q.id = :id",
            { id: arguments.questionId },
            { datasource: "stddb" }
        );

        var options = queryExecute(
            "SELECT * FROM question_options WHERE question_id = :id ORDER BY sort_order",
            { id: arguments.questionId },
            { datasource: "stddb" }
        );

        return { "question": question, "options": options };
    }

    /**
     * Create a new question with options
     */
    function createQuestion( required numeric categoryId, required numeric difficultyId,
                              required string questionText, string codeSnippet = "",
                              string explanation = "", required array options,
                              numeric createdBy = 0 ) {

        queryExecute(
            "INSERT INTO questions (category_id, difficulty_id, question_text, code_snippet, explanation, created_by)
             VALUES (:categoryId, :difficultyId, :questionText, :codeSnippet, :explanation, :createdBy)",
            {
                categoryId:   arguments.categoryId,
                difficultyId: arguments.difficultyId,
                questionText: arguments.questionText,
                codeSnippet:  arguments.codeSnippet,
                explanation:  arguments.explanation,
                createdBy:    arguments.createdBy > 0 ? arguments.createdBy : javacast("null", "")
            },
            { datasource: "stddb" }
        );

        // Get last inserted ID
        var lastId = queryExecute( "SELECT LAST_INSERT_ID() as id", {}, { datasource: "stddb" } );
        var questionId = lastId.id;

        // Insert options
        for ( var i = 1; i <= arrayLen(arguments.options); i++ ) {
            var opt = arguments.options[i];
            queryExecute(
                "INSERT INTO question_options (question_id, option_text, is_correct, sort_order)
                 VALUES (:qid, :optionText, :isCorrect, :sortOrder)",
                {
                    qid:        questionId,
                    optionText: opt.text,
                    isCorrect:  opt.isCorrect ? 1 : 0,
                    sortOrder:  i
                },
                { datasource: "stddb" }
            );
        }

        return { "success": true, "questionId": questionId };
    }

    /**
     * Update a question
     */
    function updateQuestion( required numeric questionId, required numeric categoryId,
                              required numeric difficultyId, required string questionText,
                              string codeSnippet = "", string explanation = "",
                              required array options ) {

        queryExecute(
            "UPDATE questions SET category_id = :categoryId, difficulty_id = :difficultyId,
                    question_text = :questionText, code_snippet = :codeSnippet,
                    explanation = :explanation
             WHERE id = :id",
            {
                id:           arguments.questionId,
                categoryId:   arguments.categoryId,
                difficultyId: arguments.difficultyId,
                questionText: arguments.questionText,
                codeSnippet:  arguments.codeSnippet,
                explanation:  arguments.explanation
            },
            { datasource: "stddb" }
        );

        // Delete old options and re-insert
        queryExecute(
            "DELETE FROM question_options WHERE question_id = :id",
            { id: arguments.questionId },
            { datasource: "stddb" }
        );

        for ( var i = 1; i <= arrayLen(arguments.options); i++ ) {
            var opt = arguments.options[i];
            queryExecute(
                "INSERT INTO question_options (question_id, option_text, is_correct, sort_order)
                 VALUES (:qid, :optionText, :isCorrect, :sortOrder)",
                {
                    qid:        arguments.questionId,
                    optionText: opt.text,
                    isCorrect:  opt.isCorrect ? 1 : 0,
                    sortOrder:  i
                },
                { datasource: "stddb" }
            );
        }

        return { "success": true };
    }

    /**
     * Delete a question
     */
    function deleteQuestion( required numeric questionId ) {
        queryExecute(
            "DELETE FROM questions WHERE id = :id",
            { id: arguments.questionId },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Get random questions for a test
     */
    function getRandomQuestions( numeric categoryId = 0, numeric difficultyId = 0,
                                  required numeric count ) {
        var sql = "SELECT q.id, q.question_text, q.code_snippet, q.category_id,
                          c.name as category_name, d.name as difficulty_name
                   FROM questions q
                   JOIN categories c ON q.category_id = c.id
                   JOIN difficulty_levels d ON q.difficulty_id = d.id
                   WHERE q.is_active = 1";
        var params = {};

        if ( arguments.categoryId > 0 ) {
            sql &= " AND q.category_id = :categoryId";
            params.categoryId = arguments.categoryId;
        }
        if ( arguments.difficultyId > 0 ) {
            sql &= " AND q.difficulty_id = :difficultyId";
            params.difficultyId = arguments.difficultyId;
        }

        sql &= " ORDER BY RAND() LIMIT :cnt";
        params.cnt = arguments.count;

        return queryExecute( sql, params, { datasource: "stddb" } );
    }

    /**
     * Get total question count
     */
    function getQuestionCount( numeric categoryId = 0 ) {
        var sql = "SELECT COUNT(*) as cnt FROM questions WHERE is_active = 1";
        var params = {};
        if ( arguments.categoryId > 0 ) {
            sql &= " AND category_id = :categoryId";
            params.categoryId = arguments.categoryId;
        }
        var result = queryExecute( sql, params, { datasource: "stddb" } );
        return result.cnt;
    }

}

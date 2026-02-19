/**
 * ResultService — analytics, leaderboard, dashboard stats.
 */
component singleton accessors="true" {

    /**
     * Get detailed result for an attempt
     */
    function getAttemptResult( required numeric attemptId ) {
        var attempt = queryExecute(
            "SELECT ta.*, t.title as test_title, t.total_questions, t.negative_marking,
                    t.negative_mark_value, t.pass_percentage,
                    c.name as category_name, d.name as difficulty_name
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             LEFT JOIN categories c ON t.category_id = c.id
             LEFT JOIN difficulty_levels d ON t.difficulty_id = d.id
             WHERE ta.id = :id",
            { id: arguments.attemptId },
            { datasource: "stddb" }
        );

        var answers = queryExecute(
            "SELECT aa.id as attempt_answer_id, aa.selected_option_id, aa.is_correct as answer_is_correct,
                    q.id as question_id, q.question_text, q.code_snippet, q.explanation,
                    qo.id as option_id, qo.option_text, qo.is_correct as option_is_correct, qo.sort_order,
                    c.name as test_category_name
             FROM attempt_answers aa
             JOIN questions q ON aa.question_id = q.id
             JOIN question_options qo ON q.id = qo.question_id
             LEFT JOIN categories c ON q.category_id = c.id
             WHERE aa.attempt_id = :id
             ORDER BY aa.id, qo.sort_order",
            { id: arguments.attemptId },
            { datasource: "stddb" }
        );

        return { "attempt": attempt, "answers": answers };
    }

    /**
     * Dashboard stats for a user
     */
    function getDashboardStats( required numeric userId ) {
        // Total tests taken
        var testsTaken = queryExecute(
            "SELECT COUNT(*) as cnt FROM test_attempts WHERE user_id = :userId AND status = 'completed'",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        // Average percentage
        var avgScore = queryExecute(
            "SELECT COALESCE(AVG(percentage), 0) as avg_pct FROM test_attempts WHERE user_id = :userId AND status = 'completed'",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        // Total correct / total answered
        var accuracy = queryExecute(
            "SELECT COALESCE(SUM(correct_answers), 0) as total_correct,
                    COALESCE(SUM(correct_answers + wrong_answers), 0) as total_answered
             FROM test_attempts WHERE user_id = :userId AND status = 'completed'",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        // Category-wise performance
        var categoryPerf = queryExecute(
            "SELECT c.name as category_name, c.color,
                    COUNT(DISTINCT ta.id) as tests_count,
                    COALESCE(AVG(ta.percentage), 0) as avg_pct
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             JOIN categories c ON t.category_id = c.id
             WHERE ta.user_id = :userId AND ta.status = 'completed'
             GROUP BY c.id, c.name, c.color
             ORDER BY avg_pct DESC",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        // Recent tests
        var recentTests = queryExecute(
            "SELECT ta.*, t.title as test_title, c.name as category_name, c.icon as category_icon, c.color as category_color
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             LEFT JOIN categories c ON t.category_id = c.id
             WHERE ta.user_id = :userId AND ta.status = 'completed'
             ORDER BY ta.finished_at DESC
             LIMIT 5",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        // Leaderboard rank
        var rank = queryExecute(
            "SELECT rank_position, total_score, tests_taken, avg_percentage, best_score, current_streak
             FROM leaderboard WHERE user_id = :userId",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );

        var totalAnswered = accuracy.total_answered > 0 ? accuracy.total_answered : 1;
        var accuracyPct = ( accuracy.total_correct / totalAnswered ) * 100;

        return {
            "testsTaken":   testsTaken.cnt,
            "avgScore":     numberFormat( avgScore.avg_pct, "0.0" ),
            "accuracyPct":  numberFormat( accuracyPct, "0.0" ),
            "totalCorrect": accuracy.total_correct,
            "categoryPerf": categoryPerf,
            "recentTests":  recentTests,
            "rank":         rank
        };
    }

    /**
     * Get leaderboard
     */
    function getLeaderboard( numeric limit = 50 ) {
        // Update ranks using a JOIN with a ranked subquery for better compatibility
        // Renamed variable to @current_rank to avoid conflicts
        queryExecute(
            "UPDATE leaderboard l
             JOIN (
                SELECT user_id, @current_rank := @current_rank + 1 as new_rank
                FROM leaderboard, (SELECT @current_rank := 0) r
                ORDER BY avg_percentage DESC, total_score DESC
             ) ranked ON l.user_id = ranked.user_id
             SET l.rank_position = ranked.new_rank",
            {},
            { datasource: "stddb" }
        );

        return queryExecute(
            "SELECT l.*, u.username, u.first_name, u.last_name, u.avatar
             FROM leaderboard l
             JOIN users u ON l.user_id = u.id
             WHERE l.tests_taken > 0
             ORDER BY l.rank_position ASC
             LIMIT :lim",
            { lim: arguments.limit },
            { datasource: "stddb" }
        );
    }

    /**
     * Get weak areas for a user
     */
    function getWeakAreas( required numeric userId ) {
        return queryExecute(
            "SELECT c.name as category_name, c.icon, c.color,
                    COUNT(aa.id) as total_questions,
                    SUM(CASE WHEN aa.is_correct = 1 THEN 1 ELSE 0 END) as correct,
                    ROUND(SUM(CASE WHEN aa.is_correct = 1 THEN 1 ELSE 0 END) / COUNT(aa.id) * 100, 1) as accuracy
             FROM attempt_answers aa
             JOIN questions q ON aa.question_id = q.id
             JOIN categories c ON q.category_id = c.id
             JOIN test_attempts ta ON aa.attempt_id = ta.id
             WHERE ta.user_id = :userId AND ta.status = 'completed' AND aa.selected_option_id IS NOT NULL
             GROUP BY c.id, c.name, c.icon, c.color
             HAVING accuracy < 60
             ORDER BY accuracy ASC",
            { userId: arguments.userId },
            { datasource: "stddb" }
        );
    }

    /**
     * Admin — overall platform stats
     */
    function getAdminStats() {
        var users = queryExecute( "SELECT COUNT(*) as cnt FROM users", {}, { datasource: "stddb" } );
        var questions = queryExecute( "SELECT COUNT(*) as cnt FROM questions WHERE is_active = 1", {}, { datasource: "stddb" } );
        var tests = queryExecute( "SELECT COUNT(*) as cnt FROM tests WHERE is_active = 1", {}, { datasource: "stddb" } );
        var attempts = queryExecute( "SELECT COUNT(*) as cnt FROM test_attempts WHERE status = 'completed'", {}, { datasource: "stddb" } );
        var avgScore = queryExecute( "SELECT COALESCE(AVG(percentage), 0) as avg FROM test_attempts WHERE status = 'completed'", {}, { datasource: "stddb" } );

        // Recent attempts
        var recentAttempts = queryExecute(
            "SELECT ta.*, u.username, u.first_name, u.last_name, t.title as test_title
             FROM test_attempts ta
             JOIN users u ON ta.user_id = u.id
             JOIN tests t ON ta.test_id = t.id
             WHERE ta.status = 'completed'
             ORDER BY ta.finished_at DESC LIMIT 10",
            {},
            { datasource: "stddb" }
        );

        return {
            "totalUsers":      users.cnt,
            "totalQuestions":   questions.cnt,
            "totalTests":      tests.cnt,
            "totalAttempts":    attempts.cnt,
            "avgPlatformScore": numberFormat( avgScore.avg, "0.0" ),
            "recentAttempts":   recentAttempts
        };
    }

}

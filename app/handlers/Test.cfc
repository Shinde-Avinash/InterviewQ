/**
 * Test Handler — MCQ test engine
 */
component extends="coldbox.system.EventHandler" {

    property name="testService"     inject="TestService";
    property name="resultService"   inject="ResultService";
    property name="categoryService" inject="CategoryService";

    /**
     * List available tests
     */
    function index( event, rc, prc ) {
        prc.tests      = testService.getAvailableTests( isPractice = false );
        prc.categories = categoryService.getActiveCategories();
        event.setView( "test/index" );
    }

    /**
     * Start a test
     */
    function start( event, rc, prc ) {
        param rc.testId = 0;
        var result = testService.startTest( rc.testId, session.userId );
        if ( result.success ) {
            relocate( event = "test/take", queryString = "attemptId=#result.attemptId#" );
        } else {
            flash.put( "error", result.message );
            relocate( "test" );
        }
    }

    /**
     * Take a test — the MCQ engine page
     */
    function take( event, rc, prc ) {
        param rc.attemptId = 0;

        // Verify this attempt belongs to the logged-in user and is in_progress
        var attempt = queryExecute(
            "SELECT ta.*, t.title as test_title, t.negative_marking, t.negative_mark_value, t.duration_minutes as test_duration
             FROM test_attempts ta
             JOIN tests t ON ta.test_id = t.id
             WHERE ta.id = :id AND ta.user_id = :userId",
            { id: rc.attemptId, userId: session.userId },
            { datasource: "stddb" }
        );

        if ( !attempt.recordCount ) {
            flash.put( "error", "Test attempt not found." );
            relocate( "test" );
        }

        if ( attempt.status == "completed" ) {
            relocate( event = "test/result", queryString = "attemptId=#rc.attemptId#" );
        }

        prc.attempt   = attempt;
        // Fallback for dynamic duration
        prc.attemptDuration = structKeyExists(attempt, "duration_minutes") ? attempt.duration_minutes : attempt.test_duration;
        prc.questions = testService.getAttemptQuestions( rc.attemptId );

        // Get all options for each question
        prc.allOptions = {};
        for ( var i=1; i <= prc.questions.recordCount; i++ ) {
            var qId = prc.questions.question_id[ i ];
            prc.allOptions[ qId ] = testService.getQuestionOptions( qId );
        }

        event.setView( view = "test/take", layout = "Test" );
    }

    /**
     * Submit a test
     */
    function submit( event, rc, prc ) {
        param rc.attemptId = 0;
        var result = testService.submitTest( rc.attemptId );
        if ( result.success ) {
            flash.put( "success", "Test submitted successfully!" );
            relocate( event = "test/result", queryString = "attemptId=#rc.attemptId#" );
        } else {
            flash.put( "error", result.message );
            relocate( "test" );
        }
    }

    /**
     * View test result
     */
    function result( event, rc, prc ) {
        param rc.attemptId = 0;
        prc.resultData = resultService.getAttemptResult( rc.attemptId );
        event.setView( "test/result" );
    }

}

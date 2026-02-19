/**
 * Api Handler — AJAX endpoints for the test engine and practice mode
 */
component extends="coldbox.system.EventHandler" {

    property name="testService"     inject="TestService";
    property name="questionService" inject="QuestionService";

    /**
     * Save answer via AJAX
     */
    function saveAnswer( event, rc, prc ) {
        param rc.attemptId      = 0;
        param rc.questionId     = 0;
        param rc.selectedOptionId = 0;

        var result = testService.saveAnswer( rc.attemptId, rc.questionId, rc.selectedOptionId );
        event.renderData( type = "json", data = result );
    }

    /**
     * Toggle bookmark via AJAX
     */
    function toggleBookmark( event, rc, prc ) {
        param rc.attemptId  = 0;
        param rc.questionId = 0;

        var result = testService.toggleBookmark( rc.attemptId, rc.questionId );
        event.renderData( type = "json", data = result );
    }

    /**
     * Submit test via AJAX
     */
    function submitTest( event, rc, prc ) {
        param rc.attemptId = 0;
        var result = testService.submitTest( rc.attemptId );
        event.renderData( type = "json", data = result );
    }

    /**
     * Check answer for practice mode
     */
    function checkAnswer( event, rc, prc ) {
        param rc.questionId     = 0;
        param rc.selectedOptionId = 0;

        var correct = queryExecute(
            "SELECT id, option_text FROM question_options WHERE question_id = :qid AND is_correct = 1",
            { qid: rc.questionId },
            { datasource: "stddb" }
        );

        var explanation = queryExecute(
            "SELECT explanation FROM questions WHERE id = :qid",
            { qid: rc.questionId },
            { datasource: "stddb" }
        );

        var isCorrect = correct.recordCount && correct.id == rc.selectedOptionId;

        event.renderData( type = "json", data = {
            "isCorrect":       isCorrect,
            "correctOptionId": correct.recordCount ? correct.id : 0,
            "correctText":     correct.recordCount ? correct.option_text : "",
            "explanation":     explanation.recordCount ? explanation.explanation : ""
        });
    }

}

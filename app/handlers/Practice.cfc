/**
 * Practice Handler — untimed practice mode
 */
component extends="coldbox.system.EventHandler" {

    property name="categoryService" inject="CategoryService";
    property name="questionService" inject="QuestionService";

    /**
     * Practice mode — select category
     */
    function index( event, rc, prc ) {
        prc.categories   = categoryService.getActiveCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        event.setView( "practice/index" );
    }

    /**
     * Start practice with questions
     */
    function start( event, rc, prc ) {
        param rc.categoryId   = 0;
        param rc.difficultyId = 0;
        param rc.count        = 10;

        prc.questions = questionService.getRandomQuestions(
            categoryId:   rc.categoryId,
            difficultyId: rc.difficultyId,
            count:        rc.count
        );

        // Get options for all questions
        prc.allOptions = {};
        for ( var q in prc.questions ) {
            prc.allOptions[ q.id ] = queryExecute(
                "SELECT * FROM question_options WHERE question_id = :id ORDER BY sort_order",
                { id: q.id },
                { datasource: "stddb" }
            );
        }

        prc.categoryId   = rc.categoryId;
        prc.difficultyId = rc.difficultyId;

        event.setView( "practice/start" );
    }

}

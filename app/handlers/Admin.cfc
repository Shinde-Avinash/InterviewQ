/**
 * Admin Handler — admin panel for managing questions, categories, users
 */
component extends="coldbox.system.EventHandler" {

    property name="resultService"   inject="ResultService";
    property name="questionService" inject="QuestionService";
    property name="categoryService" inject="CategoryService";
    property name="userService"     inject="UserService";
    property name="testService"     inject="TestService";

    /**
     * Admin dashboard
     */
    function index( event, rc, prc ) {
        prc.stats = resultService.getAdminStats();
        event.setLayout( "Admin" );
        event.setView( "admin/index" );
    }

    /**
     * List questions
     */
    function questions( event, rc, prc ) {
        param rc.page         = 1;
        param rc.categoryId   = 0;
        param rc.difficultyId = 0;
        param rc.search       = "";

        prc.data         = questionService.getQuestions( rc.page, 20, rc.categoryId, rc.difficultyId, rc.search );
        prc.categories   = categoryService.getAllCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        event.setLayout( "Admin" );
        event.setView( "admin/questions" );
    }

    /**
     * Create question form
     */
    function createQuestion( event, rc, prc ) {
        prc.question     = queryNew("id,category_id,difficulty_id,question_text,code_snippet,explanation","integer,integer,integer,varchar,varchar,varchar");
        prc.options      = queryNew("id,option_text,is_correct,sort_order","integer,varchar,bit,integer");
        prc.categories   = categoryService.getAllCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        prc.isEdit       = false;
        event.setLayout( "Admin" );
        event.setView( "admin/questionForm" );
    }

    /**
     * Edit question form
     */
    function editQuestion( event, rc, prc ) {
        param rc.questionId = 0;
        var data = questionService.getQuestionById( rc.questionId );
        prc.question     = data.question;
        prc.options      = data.options;
        prc.categories   = categoryService.getAllCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        prc.isEdit       = true;
        event.setLayout( "Admin" );
        event.setView( "admin/questionForm" );
    }

    /**
     * Save question (create or update)
     */
    function saveQuestion( event, rc, prc ) {
        param rc.questionId   = 0;
        param rc.categoryId   = 1;
        param rc.difficultyId = 1;
        param rc.questionText = "";
        param rc.codeSnippet  = "";
        param rc.explanation  = "";

        // Build options array
        var options = [];
        for ( var i = 1; i <= 4; i++ ) {
            if ( structKeyExists(rc, "option_#i#") && len(trim(rc["option_#i#"])) ) {
                arrayAppend( options, {
                    "text":      rc["option_#i#"],
                    "isCorrect": structKeyExists(rc, "correct") && rc.correct == i
                });
            }
        }

        if ( rc.questionId > 0 ) {
            questionService.updateQuestion(
                questionId:   rc.questionId,
                categoryId:   rc.categoryId,
                difficultyId: rc.difficultyId,
                questionText: rc.questionText,
                codeSnippet:  rc.codeSnippet,
                explanation:  rc.explanation,
                options:      options
            );
            flash.put( "success", "Question updated successfully!" );
        } else {
            questionService.createQuestion(
                categoryId:   rc.categoryId,
                difficultyId: rc.difficultyId,
                questionText: rc.questionText,
                codeSnippet:  rc.codeSnippet,
                explanation:  rc.explanation,
                options:      options,
                createdBy:    session.userId
            );
            flash.put( "success", "Question created successfully!" );
        }
        relocate( "admin/questions" );
    }

    /**
     * Delete question
     */
    function deleteQuestion( event, rc, prc ) {
        param rc.questionId = 0;
        questionService.deleteQuestion( rc.questionId );
        flash.put( "success", "Question deleted." );
        relocate( "admin/questions" );
    }

    /**
     * Categories management
     */
    function categories( event, rc, prc ) {
        prc.categories = categoryService.getAllCategories();
        event.setLayout( "Admin" );
        event.setView( "admin/categories" );
    }

    /**
     * Save category
     */
    function saveCategory( event, rc, prc ) {
        param rc.categoryId  = 0;
        param rc.name        = "";
        param rc.slug        = "";
        param rc.description = "";
        param rc.icon        = "fa-code";
        param rc.color       = "##6366f1";

        if ( !len(trim(rc.slug)) ) {
            rc.slug = lCase( reReplace( rc.name, "[^a-zA-Z0-9]", "-", "ALL" ) );
        }

        if ( rc.categoryId > 0 ) {
            categoryService.updateCategory( rc.categoryId, rc.name, rc.slug, rc.description, rc.icon, rc.color );
            flash.put( "success", "Category updated!" );
        } else {
            categoryService.createCategory( rc.name, rc.slug, rc.description, rc.icon, rc.color );
            flash.put( "success", "Category created!" );
        }
        relocate( "admin/categories" );
    }

    /**
     * Delete category
     */
    function deleteCategory( event, rc, prc ) {
        param rc.categoryId = 0;
        var result = categoryService.deleteCategory( rc.categoryId );
        if ( result.success ) {
            flash.put( "success", "Category deleted." );
        } else {
            flash.put( "error", result.message );
        }
        relocate( "admin/categories" );
    }

    /**
     * Users management
     */
    function users( event, rc, prc ) {
        prc.users = userService.getAllUsers();
        event.setLayout( "Admin" );
        event.setView( "admin/users" );
    }

    /**
     * Create user form
     */
    function createUser( event, rc, prc ) {
        prc.targetUser = queryNew("id,username,email,first_name,last_name,role_id,is_active","integer,varchar,varchar,varchar,varchar,integer,bit");
        prc.roles      = userService.getRoles();
        prc.isEdit     = false;
        event.setLayout( "Admin" );
        event.setView( "admin/userForm" );
    }

    /**
     * Edit user form
     */
    function editUser( event, rc, prc ) {
        param rc.userId = 0;
        prc.targetUser = userService.getUserById( rc.userId );
        prc.roles      = userService.getRoles();
        prc.isEdit     = true;
        event.setLayout( "Admin" );
        event.setView( "admin/userForm" );
    }

    /**
     * Save user (create or update)
     */
    function saveUser( event, rc, prc ) {
        param rc.userId    = 0;
        param rc.username  = "";
        param rc.email     = "";
        param rc.password  = "";
        param rc.firstName = "";
        param rc.lastName  = "";
        param rc.roleId    = 2;

        if ( rc.userId > 0 ) {
            userService.updateUser( rc.userId, rc.username, rc.email, rc.firstName, rc.lastName, rc.roleId, rc.password );
            flash.put( "success", "User [ #rc.username# ] updated successfully!" );
        } else {
            var result = userService.register( rc.username, rc.email, rc.password, rc.firstName, rc.lastName, rc.roleId );
            if ( result.success ) {
                flash.put( "success", "User [ #rc.username# ] created successfully!" );
            } else {
                flash.put( "error", result.message );
                return relocate( "admin/createUser" );
            }
        }
        relocate( "admin/users" );
    }

    /**
     * Delete user
     */
    function deleteUser( event, rc, prc ) {
        param rc.userId = 0;
        userService.deleteUser( rc.userId );
        flash.put( "success", "User deleted permanently." );
        relocate( "admin/users" );
    }

    /**
     * Toggle user status
     */
    function toggleUser( event, rc, prc ) {
        param rc.userId = 0;
        userService.toggleUserStatus( rc.userId );
        flash.put( "success", "User status updated." );
        relocate( "admin/users" );
    }

    /**
     * List tests
     */
    function tests( event, rc, prc ) {
        prc.tests = testService.getAvailableTests();
        prc.practiceTests = testService.getAvailableTests( isPractice = true );
        event.setLayout( "Admin" );
        event.setView( "admin/tests" );
    }

    /**
     * Create test form
     */
    function createTest( event, rc, prc ) {
        prc.test         = queryNew("id,title,description,category_id,difficulty_id,total_questions,time_minutes,is_practice,negative_marking,negative_mark_value,is_active","integer,varchar,varchar,integer,integer,integer,integer,bit,bit,decimal,bit");
        prc.categories   = categoryService.getAllCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        prc.isEdit       = false;
        event.setLayout( "Admin" );
        event.setView( "admin/testForm" );
    }

    /**
     * Edit test form
     */
    function editTest( event, rc, prc ) {
        param rc.testId = 0;
        prc.test         = testService.getTestById( rc.testId );
        prc.categories   = categoryService.getAllCategories();
        prc.difficulties = categoryService.getDifficultyLevels();
        prc.isEdit       = true;
        event.setLayout( "Admin" );
        event.setView( "admin/testForm" );
    }

    /**
     * Save test (create or update)
     */
    function saveTest( event, rc, prc ) {
        param rc.testId             = 0;
        param rc.title              = "";
        param rc.description        = "";
        param rc.categoryId         = 0;
        param rc.difficultyId       = 0;
        param rc.totalQuestions     = 10;
        param rc.timeMinutes        = 30;
        param rc.isPractice         = false;
        param rc.negativeMarking    = false;
        param rc.negativeMarkValue  = 0.25;
        param rc.isActive           = true;

        if ( rc.testId > 0 ) {
            testService.updateTest(
                testId:             rc.testId,
                title:              rc.title,
                description:        rc.description,
                categoryId:         rc.categoryId,
                difficultyId:       rc.difficultyId,
                totalQuestions:     rc.totalQuestions,
                timeMinutes:        rc.timeMinutes,
                isPractice:         rc.isPractice,
                negativeMarking:    rc.negativeMarking,
                negativeMarkValue:  rc.negativeMarkValue,
                isActive:           rc.isActive
            );
            flash.put( "success", "Test updated successfully!" );
        } else {
            testService.createTest(
                title:              rc.title,
                description:        rc.description,
                categoryId:         rc.categoryId,
                difficultyId:       rc.difficultyId,
                totalQuestions:     rc.totalQuestions,
                timeMinutes:        rc.timeMinutes,
                isPractice:         rc.isPractice,
                negativeMarking:    rc.negativeMarking,
                negativeMarkValue:  rc.negativeMarkValue
            );
            flash.put( "success", "Test created successfully!" );
        }
        relocate( "admin/tests" );
    }

    /**
     * Delete test
     */
    function deleteTest( event, rc, prc ) {
        param rc.testId = 0;
        testService.deleteTest( rc.testId );
        flash.put( "success", "Test archived." );
        relocate( "admin/tests" );
    }

}

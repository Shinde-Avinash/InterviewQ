component {

    function configure(){

        // Auth routes
        route( "/login" ).to( "auth.login" );
        route( "/register" ).to( "auth.register" );
        route( "/logout" ).to( "auth.logout" );

        // API routes (AJAX)
        route( "/api/saveAnswer" ).to( "api.saveAnswer" );
        route( "/api/toggleBookmark" ).to( "api.toggleBookmark" );
        route( "/api/submitTest" ).to( "api.submitTest" );
        route( "/api/checkAnswer" ).to( "api.checkAnswer" );

        // Conventions-Based Routing
        route( ":handler/:action?" ).end();
    }

}

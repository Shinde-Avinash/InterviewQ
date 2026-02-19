/**
 * AuthInterceptor — protects routes that require authentication
 */
component {

    function configure() {}

    /**
     * Fires before every request
     */
    function preProcess( event, interceptData, rc, prc ) {
        var currentEvent  = event.getCurrentEvent();
        var currentAction = lCase( currentEvent );

        // Public routes that don't require auth
        var publicRoutes = [
            "main.index",
            "auth.login",
            "auth.dologin",
            "auth.register",
            "auth.doregister",
            "auth.forgotpassword",
            "auth.logout"
        ];

        // Check if current route is public
        var isPublic = false;
        for ( var route in publicRoutes ) {
            if ( currentAction == route ) {
                isPublic = true;
                break;
            }
        }

        // If route is not public, require authentication
        if ( !isPublic ) {
            if ( !structKeyExists( session, "isLoggedIn" ) || !session.isLoggedIn ) {
                relocate( "auth/login" );
            }
        }

        // Admin route protection
        if ( findNoCase( "admin", currentAction ) && structKeyExists( session, "isLoggedIn" ) && session.isLoggedIn ) {
            if ( session.roleName != "Admin" ) {
                relocate( "dashboard" );
            }
        }
    }

}

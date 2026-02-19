/**
 * Auth Handler — login, register, logout
 */
component extends="coldbox.system.EventHandler" {

    property name="userService" inject="UserService";

    /**
     * Login page
     */
    function login( event, rc, prc ) {
        if ( structKeyExists( session, "isLoggedIn" ) && session.isLoggedIn ) {
            relocate( "dashboard" );
        }
        prc.isAuthPage = true;
        event.setView( "auth/login" );
    }

    /**
     * Process login
     */
    function doLogin( event, rc, prc ) {
        param rc.username = "";
        param rc.password = "";

        if ( !len(trim(rc.username)) || !len(trim(rc.password)) ) {
            flash.put( "error", "Please enter both username and password." );
            relocate( "auth/login" );
        }

        var result = userService.authenticate( rc.username, rc.password );

        if ( result.success ) {
            session.isLoggedIn = true;
            session.user      = result.user;
            session.userId    = result.user.id;
            session.roleId    = result.user.roleId;
            session.roleName  = result.user.roleName;
            session.username  = result.user.username;

            if ( result.user.roleName == "Admin" ) {
                relocate( "admin" );
            } else {
                relocate( "dashboard" );
            }
        } else {
            flash.put( "error", result.message );
            relocate( "auth/login" );
        }
    }

    /**
     * Registration page
     */
    function register( event, rc, prc ) {
        prc.isAuthPage = true;
        event.setView( "auth/register" );
    }

    /**
     * Process registration
     */
    function doRegister( event, rc, prc ) {
        param rc.username  = "";
        param rc.email     = "";
        param rc.password  = "";
        param rc.firstName = "";
        param rc.lastName  = "";

        if ( !len(trim(rc.username)) || !len(trim(rc.email)) || !len(trim(rc.password)) ) {
            flash.put( "error", "Please fill in all required fields." );
            relocate( "auth/register" );
        }

        var result = userService.register(
            username:  rc.username,
            email:     rc.email,
            password:  rc.password,
            firstName: rc.firstName,
            lastName:  rc.lastName
        );

        if ( result.success ) {
            flash.put( "success", "Registration successful! Please log in." );
            relocate( "auth/login" );
        } else {
            flash.put( "error", result.message );
            relocate( "auth/register" );
        }
    }

    /**
     * Logout
     */
    function logout( event, rc, prc ) {
        structClear( session );
        flash.put( "success", "You have been logged out." );
        relocate( "auth/login" );
    }

    /**
     * Forgot password page
     */
    function forgotPassword( event, rc, prc ) {
        prc.isAuthPage = true;
        event.setView( "auth/forgotPassword" );
    }

}

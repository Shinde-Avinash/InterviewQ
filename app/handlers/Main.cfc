/**
 * Main Handler — Landing page
 */
component extends="coldbox.system.EventHandler" {

    /**
     * Landing page — redirect to dashboard if logged in
     */
    function index( event, rc, prc ) {
        if ( structKeyExists( session, "isLoggedIn" ) && session.isLoggedIn ) {
            if ( session.roleName == "Admin" ) {
                relocate( "admin" );
            } else {
                relocate( "dashboard" );
            }
        }
        event.setView( "main/index" );
    }

    /************************************** IMPLICIT ACTIONS *********************************************/

    function onAppInit( event, rc, prc ) {}
    function onRequestStart( event, rc, prc ) {}
    function onRequestEnd( event, rc, prc ) {}
    function onSessionStart( event, rc, prc ) {}

    function onSessionEnd( event, rc, prc ) {
        var sessionScope     = event.getValue( "sessionReference" );
        var applicationScope = event.getValue( "applicationReference" );
    }

    function onException( event, rc, prc ) {
        event.setHTTPHeader( statusCode = 500 );
        var exception = prc.exception;
    }

}

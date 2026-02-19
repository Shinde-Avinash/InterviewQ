/**
 * Dashboard Handler — personalized student dashboard
 */
component extends="coldbox.system.EventHandler" {

    property name="resultService" inject="ResultService";

    /**
     * Student dashboard
     */
    function index( event, rc, prc ) {
        prc.stats = resultService.getDashboardStats( session.userId );
        event.setView( "dashboard/index" );
    }

}

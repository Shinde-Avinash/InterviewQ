/**
 * Leaderboard Handler
 */
component extends="coldbox.system.EventHandler" {

    property name="resultService" inject="ResultService";

    function index( event, rc, prc ) {
        prc.leaderboard = resultService.getLeaderboard();
        event.setView( "leaderboard/index" );
    }

}

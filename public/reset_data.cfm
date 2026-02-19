<cfscript>
    try {
        // 1. Clear Attempt Answers (Child table)
        queryExecute("DELETE FROM attempt_answers", {}, { datasource: "stddb" });
        
        // 2. Clear Test Attempts
        queryExecute("DELETE FROM test_attempts", {}, { datasource: "stddb" });
        
        // 3. Clear Leaderboard
        queryExecute("DELETE FROM leaderboard", {}, { datasource: "stddb" });

        writeOutput("<h1>Success</h1><p>All test attempts and leaderboard data have been cleared successfully.</p>");
    } catch (any e) {
        writeOutput("<h1>Error</h1><p>" + e.message + "</p>");
        if (structKeyExists(e, "detail")) writeOutput("<p>" + e.detail + "</p>");
    }
</cfscript>

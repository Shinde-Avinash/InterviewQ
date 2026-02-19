<cfscript>
    try {
        queryExecute("ALTER TABLE test_attempts ADD COLUMN duration_minutes INT NOT NULL DEFAULT 15 AFTER user_id", {}, { datasource: "stddb" });
        writeOutput("<h1>Success</h1><p>Column 'duration_minutes' added successfully to 'test_attempts'.</p>");
    } catch (any e) {
        writeOutput("<h1>Error</h1><p>" + e.message + "</p>");
        if (structKeyExists(e, "detail")) writeOutput("<p>" + e.detail + "</p>");
    }
</cfscript>

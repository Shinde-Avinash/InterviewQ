<cfscript>
    try {
        cats = queryExecute("SELECT id, name FROM categories", {}, {datasource="stddb"});
        tests = queryExecute("SELECT id, title, category_id FROM tests", {}, {datasource="stddb"});
        counts = queryExecute("SELECT category_id, COUNT(*) as c FROM questions WHERE is_active = 1 GROUP BY category_id", {}, {datasource="stddb"});
        
        data = {
            "categories": [],
            "tests": [],
            "counts": []
        };
        
        for (row in cats) { data.categories.append({"id": row.id, "name": row.name}); }
        for (row in tests) { data.tests.append({"id": row.id, "title": row.title, "catId": row.category_id}); }
        for (row in counts) { data.counts.append({"catId": row.category_id, "count": row.c}); }
        
        fileWrite(expandPath("db_counts.json"), serializeJSON(data));
        writeOutput("JSON_WRITTEN_SUCCESSFULLY");
    } catch (any e) {
        writeOutput("ERROR: " & e.message);
    }
</cfscript>

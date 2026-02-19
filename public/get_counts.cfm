<cfscript>
    try {
        cats = queryExecute("SELECT id, name FROM categories", {}, {datasource="stddb"});
        tests = queryExecute("SELECT id, title, category_id FROM tests", {}, {datasource="stddb"});
        counts = queryExecute("SELECT category_id, COUNT(*) as c FROM questions WHERE is_active = 1 GROUP BY category_id", {}, {datasource="stddb"});
        
        out = "CATEGORIES:#chr(10)#";
        for (row in cats) {
            out &= "ID: #row.id#, Name: #row.name##chr(10)#";
        }
        
        out &= "#chr(10)#TESTS:#chr(10)#";
        for (row in tests) {
            out &= "ID: #row.id#, Title: #row.title#, CatID: #row.category_id##chr(10)#";
        }
        
        out &= "#chr(10)#ACTIVE QUESTION COUNTS:#chr(10)#";
        for (row in counts) {
            out &= "CatID: #row.category_id#, Count: #row.c##chr(10)#";
        }
        
        fileWrite(expandPath("db_counts.txt"), out);
        writeOutput("File written to public/db_counts.txt");
    } catch (any e) {
        fileWrite(expandPath("db_error.txt"), e.message);
        writeOutput("Error: " & e.message);
    }
</cfscript>

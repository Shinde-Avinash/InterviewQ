<cfscript>
    function dumpQuery(sql, params={}) {
        try {
            var q = queryExecute(arguments.sql, arguments.params, {datasource="stddb"});
            writeOutput("<h3>SQL: #arguments.sql#</h3>");
            writeDump(q);
        } catch (any e) {
            writeOutput("<h3 style='color:red'>Error: #e.message#</h3>");
        }
    }

    writeOutput("<h1>Comprehensive Database Diagnostics</h1>");

    writeOutput("<h2>1. Categories</h2>");
    dumpQuery("SELECT id, name, is_active FROM categories");

    writeOutput("<h2>2. Tests and their Category IDs</h2>");
    dumpQuery("SELECT id, title, category_id, is_active FROM tests");

    writeOutput("<h2>3. Question Counts per Category</h2>");
    dumpQuery("SELECT category_id, COUNT(*) as total, SUM(CASE WHEN is_active=1 THEN 1 ELSE 0 END) as active_count FROM questions GROUP BY category_id");

    writeOutput("<h2>4. All Questions for ColdFusion Categories</h2>");
    dumpQuery("SELECT q.id, q.question_text, q.is_active, q.category_id, c.name as category_name 
               FROM questions q 
               JOIN categories c ON q.category_id = c.id 
               WHERE c.name LIKE '%ColdFusion%'");

    writeOutput("<h2>5. Current Active Attempts</h2>");
    dumpQuery("SELECT ta.id, ta.test_id, ta.user_id, ta.status, ta.total_marks, t.title 
               FROM test_attempts ta 
               JOIN tests t ON ta.test_id = t.id 
               WHERE ta.status = 'in_progress'");

</cfscript>

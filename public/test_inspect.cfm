<cfscript>
    // Inspect ColdFusion Category and Questions
    cat = queryExecute("SELECT * FROM categories WHERE name LIKE '%ColdFusion%'", {}, {datasource="stddb"});
    writeOutput("<h2>Category Info</h2>");
    writeDump(cat);

    if (cat.recordCount) {
        questions = queryExecute("SELECT id, question_text, is_active, category_id FROM questions WHERE category_id = :catId", {catId: cat.id}, {datasource="stddb"});
        writeOutput("<h2>Questions in this Category</h2>");
        writeDump(questions);

        tests = queryExecute("SELECT * FROM tests WHERE category_id = :catId", {catId: cat.id}, {datasource="stddb"});
        writeOutput("<h2>Tests for this Category</h2>");
        writeDump(tests);

        if (tests.recordCount) {
            attempts = queryExecute("SELECT * FROM test_attempts WHERE test_id = :testId AND status = 'in_progress'", {testId: tests.id}, {datasource="stddb"});
            writeOutput("<h2>Active (In-Progress) Attempts for this Test</h2>");
            writeDump(attempts);

            if (attempts.recordCount) {
                answers = queryExecute("SELECT * FROM attempt_answers WHERE attempt_id = :attId", {attId: attempts.id}, {datasource="stddb"});
                writeOutput("<h2>Answers/Questions in the Current Active Attempt</h2>");
                writeDump(answers);
            }
        }
    } else {
        writeOutput("ColdFusion category not found!");
    }
</cfscript>

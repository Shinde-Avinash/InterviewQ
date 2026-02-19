<cfscript>
    data = {};
    data.categories = queryExecute("SELECT * FROM categories", {}, {datasource="stddb"}).reduce(function(acc, row){
        acc.append(row);
        return acc;
    }, []);
    
    data.tests = queryExecute("SELECT * FROM tests", {}, {datasource="stddb"}).reduce(function(acc, row){
        acc.append(row);
        return acc;
    }, []);
    
    data.question_counts = queryExecute("SELECT category_id, COUNT(*) as count FROM questions WHERE is_active = 1 GROUP BY category_id", {}, {datasource="stddb"}).reduce(function(acc, row){
        acc.append(row);
        return acc;
    }, []);

    fileWrite("c:\Users\om\Desktop\TEMP_FILES\2-Avinash\ColdFusion\InterviewPrep\db_dump.json", serializeJSON(data));
</cfscript>

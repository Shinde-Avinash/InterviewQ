<cfoutput>
<div class="page-header">
    <h1 class="page-title">
        <cfif prc.isEdit>Edit Question<cfelse>Add New Question</cfif>
    </h1>
</div>

<div class="dk-card" style="max-width:800px">
    <form action="#event.buildLink('admin/saveQuestion')#" method="POST">
        <cfif prc.isEdit AND prc.question.recordCount>
            <input type="hidden" name="questionId" value="#prc.question.id#">
        </cfif>

        <div class="row g-3 mb-4">
            <div class="col-md-6">
                <label class="form-label">Category</label>
                <select name="categoryId" class="form-select" required>
                    <cfloop query="prc.categories">
                        <option value="#id#" <cfif prc.isEdit AND prc.question.recordCount AND prc.question.category_id EQ id>selected</cfif>>#name#</option>
                    </cfloop>
                </select>
            </div>
            <div class="col-md-6">
                <label class="form-label">Difficulty</label>
                <select name="difficultyId" class="form-select" required>
                    <cfloop query="prc.difficulties">
                        <option value="#id#" <cfif prc.isEdit AND prc.question.recordCount AND prc.question.difficulty_id EQ id>selected</cfif>>#name#</option>
                    </cfloop>
                </select>
            </div>
        </div>

        <div class="mb-3">
            <label class="form-label">Question Text</label>
            <textarea name="questionText" class="form-control" rows="3" required><cfif prc.isEdit AND prc.question.recordCount>#prc.question.question_text#</cfif></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Code Snippet <span style="color:##475569;font-weight:normal;text-transform:none">(optional)</span></label>
            <textarea name="codeSnippet" class="form-control" rows="4" style="font-family:monospace"><cfif prc.isEdit AND prc.question.recordCount>#prc.question.code_snippet#</cfif></textarea>
        </div>

        <div class="mb-3">
            <label class="form-label">Explanation</label>
            <textarea name="explanation" class="form-control" rows="2"><cfif prc.isEdit AND prc.question.recordCount>#prc.question.explanation#</cfif></textarea>
        </div>

        <hr style="border-color:rgba(56,189,248,0.08)">
        <h6 style="font-weight:600;color:##fff;margin-bottom:16px">Options <span style="color:##64748b;font-weight:normal;font-size:12px;text-transform:none">— select the correct answer</span></h6>

        <cfloop from="1" to="4" index="i">
            <div class="d-flex align-items-center gap-3 mb-3" style="animation:fadeSlideUp 0.3s ease <cfif i EQ 1>0.1s<cfelseif i EQ 2>0.15s<cfelseif i EQ 3>0.2s<cfelse>0.25s</cfif> both">
                <div class="form-check">
                    <input class="form-check-input" type="radio" name="correct" value="#i#"
                           id="correct_#i#"
                           <cfif prc.isEdit AND prc.options.recordCount GTE i AND prc.options.is_correct[i]>checked</cfif>
                           required>
                    <label class="form-check-label" for="correct_#i#" style="color:##38bdf8;font-weight:700">#chr(64+i)#</label>
                </div>
                <input type="text" name="option_#i#" class="form-control"
                       placeholder="Option #chr(64+i)#"
                       value="<cfif prc.isEdit AND prc.options.recordCount GTE i>#prc.options.option_text[i]#</cfif>"
                       required>
            </div>
        </cfloop>

        <div class="d-flex gap-2 mt-4">
            <button type="submit" class="dk-btn sky">
                <i class="fas fa-save"></i>
                <cfif prc.isEdit>Update<cfelse>Create</cfif> Question
            </button>
            <a href="#event.buildLink('admin/questions')#" class="dk-btn ghost">Cancel</a>
        </div>
    </form>
</div>
</cfoutput>

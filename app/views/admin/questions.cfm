<cfoutput>
<div class="page-header">
    <h1 class="page-title">Questions</h1>
    <p class="page-desc">Manage your question bank</p>
</div>

<div class="d-flex justify-content-between align-items-end mb-3" style="animation:fadeSlideUp 0.4s ease both">
    <form action="#event.buildLink('admin/questions')#" method="GET" class="d-flex gap-2 align-items-end">
        <div>
            <label class="form-label">Category</label>
            <select name="categoryId" class="form-select form-select-sm" style="min-width:130px">
                <option value="0">All</option>
                <cfloop query="prc.categories">
                    <option value="#id#" <cfif id EQ rc.categoryId>selected</cfif>>#name#</option>
                </cfloop>
            </select>
        </div>
        <div>
            <label class="form-label">Difficulty</label>
            <select name="difficultyId" class="form-select form-select-sm" style="min-width:110px">
                <option value="0">All</option>
                <cfloop query="prc.difficulties">
                    <option value="#id#" <cfif id EQ rc.difficultyId>selected</cfif>>#name#</option>
                </cfloop>
            </select>
        </div>
        <div>
            <label class="form-label">Search</label>
            <input type="text" name="search" value="#rc.search#" class="form-control form-control-sm" placeholder="Search...">
        </div>
        <button type="submit" class="dk-btn ghost" style="padding:6px 14px;font-size:12px"><i class="fas fa-filter"></i> Filter</button>
    </form>
    <a href="#event.buildLink('admin/createQuestion')#" class="dk-btn sky">
        <i class="fas fa-plus"></i> Add Question
    </a>
</div>

<div class="dk-table-wrap">
    <table class="table">
        <thead>
            <tr>
                <th style="width:50px">ID</th>
                <th>Question</th>
                <th>Category</th>
                <th>Difficulty</th>
                <th style="width:100px">Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="prc.data.questions">
                <tr>
                    <td style="font-weight:600;color:##38bdf8">#id#</td>
                    <td>
                        <div style="max-width:400px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;color:##e2e8f0">
                            #question_text#
                        </div>
                    </td>
                    <td><span class="dk-badge sky">#category_name#</span></td>
                    <td><span class="dk-badge amber">#difficulty_name#</span></td>
                    <td>
                        <div class="d-flex gap-1">
                            <a href="#event.buildLink('admin/editQuestion')#?questionId=#id#" class="dk-btn-icon" title="Edit">
                                <span style="font-size:14px">📝</span>
                            </a>
                            <button class="bg-transparent border-0 p-0 ms-2"
                                    onclick="confirmDelete('Delete this question?', '#event.buildLink('admin/deleteQuestion')#?questionId=#id#')" title="Delete" style="cursor:pointer">
                                <span style="font-size:14px">🗑️</span>
                            </button>
                        </div>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
</div>

<cfif prc.data.totalPages GT 1>
<nav class="mt-3">
    <ul class="pagination pagination-sm justify-content-center">
        <cfloop from="1" to="#prc.data.totalPages#" index="p">
            <li class="page-item <cfif p EQ rc.page>active</cfif>">
                <a class="page-link" href="#event.buildLink('admin/questions')#?page=#p#&categoryId=#rc.categoryId#&difficultyId=#rc.difficultyId#&search=#rc.search#">#p#</a>
            </li>
        </cfloop>
    </ul>
</nav>
</cfif>
</cfoutput>

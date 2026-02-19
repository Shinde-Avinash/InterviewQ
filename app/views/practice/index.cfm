<cfoutput>
<div class="container container-dark pb-5">
    <div class="page-header text-center" style="animation:fadeSlideUp 0.4s ease both">
        <h1 class="page-title">Practice Mode</h1>
        <p class="page-desc">No timer, no pressure. Select a topic and master your skills.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="dk-card" style="animation-delay:0.1s">
                <form action="#event.buildLink('practice/start')#" method="GET">
                    <div class="mb-4">
                        <label class="form-label">Category</label>
                        <select name="categoryId" class="form-select">
                            <option value="0">All Categories</option>
                            <cfloop query="prc.categories">
                                <option value="#id#">#name# (#question_count# questions)</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Difficulty</label>
                        <select name="difficultyId" class="form-select">
                            <option value="0">All Difficulties</option>
                            <cfloop query="prc.difficulties">
                                <option value="#id#">#name#</option>
                            </cfloop>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label">Number of Questions</label>
                        <select name="count" class="form-select">
                            <option value="5">5 Questions</option>
                            <option value="10" selected>10 Questions</option>
                            <option value="20">20 Questions</option>
                            <option value="50">50 Questions</option>
                        </select>
                    </div>
                    <button type="submit" class="dk-btn sky w-100 mt-2" style="justify-content:center;padding:12px;font-size:15px;font-weight:700">
                        <i class="fas fa-play me-2"></i> Start Practice Session
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div class="row g-3 mt-4">
        <div class="col-12">
            <h3 style="font-size:13px;font-weight:900;color:rgba(148,163,184,0.5);margin-bottom:16px;display:flex;align-items:center;gap:10px;letter-spacing:1px;text-transform:uppercase">
                <i class="fas fa-microscope" style="color:var(--sky-blue);font-size:12px"></i> 
                Research Fleet
            </h3>
        </div>
        <cfloop query="prc.categories">
        <div class="col-6 col-md-4 col-xl-3" style="animation:fadeSlideUp 0.4s ease both;animation-delay:#(currentRow * 0.05)#s">
            <a href="#event.buildLink('practice/start')#?categoryId=#id#" class="dk-tile h-100" style="padding:15px">
                <div class="tile-emoji" style="font-size:24px;margin-bottom:8px">
                    <cfif name CONTAINS "ColdFusion">🧪<cfelseif name CONTAINS "JS" OR name CONTAINS "Java">⚡<cfelseif name CONTAINS "SQL">📑<cfelseif name CONTAINS "Coding">💻<cfelse>🔋</cfif>
                </div>
                <div class="text-center">
                    <div style="font-weight:900;font-size:13px;color:##fff;letter-spacing:-0.2px">#name#</div>
                    <div style="font-size:10px;color:rgba(56,189,248,0.5);font-weight:700;margin-top:2px;text-transform:uppercase">#question_count# Units</div>
                </div>
            </a>
        </div>
        </cfloop>
    </div>
</div>
</cfoutput>

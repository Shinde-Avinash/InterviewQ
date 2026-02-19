<cfoutput>
<div class="container container-dark pb-5">
    <div class="page-header" style="animation:fadeSlideUp 0.4s ease both">
        <h1 class="page-title">Available Tests</h1>
        <p class="page-desc">Choose a test challenge and prove your technical mastery.</p>
    </div>

    <div class="row g-3">
        <cfloop query="prc.tests">
        <div class="col-md-6 col-lg-4 col-xl-3" style="animation:fadeSlideUp 0.4s ease both;animation-delay:#(currentRow * 0.05)#s">
            <div class="dk-card elite h-100 d-flex flex-column" style="padding:18px">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div style="width:40px;height:40px;border-radius:10px;background:rgba(56,189,248,0.1);display:flex;align-items:center;justify-content:center;font-size:18px">
                        <cfif category_name CONTAINS "ColdFusion">🧪<cfelseif category_name CONTAINS "Java">💻<cfelseif category_name CONTAINS "Database">📑<cfelse>🔋</cfif>
                    </div>
                    <div style="font-size:9px;font-weight:800;color:rgba(148,163,184,0.4);letter-spacing:1px;text-transform:uppercase">OPERATIONAL INTEL</div>
                </div>

                <div style="font-weight:900;font-size:15px;color:##fff;margin-bottom:8px;line-height:1.2;letter-spacing:-0.3px">#title#</div>
                <div style="font-size:12px;color:rgba(148,163,184,0.7);margin-bottom:18px;line-height:1.5;flex:1">#description#</div>
                
                <div class="d-flex flex-wrap gap-1 mb-3">
                    <span class="dk-badge sky" style="background:rgba(56,189,248,0.06);border:1px solid rgba(56,189,248,0.1);font-size:9px">📡 #category_name#</span>
                    <span class="dk-badge <cfif difficulty_name EQ 'Beginner'>green<cfelseif difficulty_name EQ 'Intermediate'>amber<cfelse>red</cfif>" style="font-size:9px">
                        ⚡ #difficulty_name#
                    </span>
                </div>
                
                <a href="#event.buildLink('test/start')#?testId=#id#" class="dk-btn sky w-100" style="justify-content:center;font-weight:800;padding:8px;border-radius:10px;font-size:12px">
                    <i class="fas fa-bolt-lightning me-1"></i> INITIATE MISSION
                </a>
            </div>
        </div>
        </cfloop>

        <cfif NOT prc.tests.recordCount>
        <div class="col-12 py-5 text-center" style="animation:fadeSlideUp 0.4s ease both">
            <div class="dk-card" style="display:inline-block;padding:40px 60px">
                <i class="fas fa-clipboard-list fa-3x mb-3" style="color:var(--border-glow);opacity:0.2"></i>
                <p style="color:var(--text-muted);font-size:14px;margin:0">No tests available yet. Check back soon for new challenges.</p>
            </div>
        </div>
        </cfif>
    </div>
</div>
</cfoutput>

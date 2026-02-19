<cfoutput>
<div class="page-header">
    <h1 class="page-title">Dashboard</h1>
    <p class="page-desc">Welcome back, Admin. Here's your performance overview.</p>
</div>

<div class="row g-3 mb-5">
    <div class="col-md-3">
        <div class="dk-tile" style="animation-delay:0.1s">
            <div class="tile-emoji">👥</div>
            <div class="stat-value">#prc.stats.totalUsers#</div>
            <div class="tile-label">Total Users</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="dk-tile" style="animation-delay:0.2s">
            <div class="tile-emoji">🛠️</div>
            <div class="stat-value">#prc.stats.totalQuestions#</div>
            <div class="tile-label">Active Questions</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="dk-tile" style="animation-delay:0.3s">
            <div class="tile-emoji">🚀</div>
            <div class="stat-value">#prc.stats.totalTests#</div>
            <div class="tile-label">Total Tests</div>
        </div>
    </div>
    <div class="col-md-3">
        <div class="dk-tile" style="animation-delay:0.4s">
            <div class="tile-emoji">📈</div>
            <div class="stat-value">#prc.stats.totalAttempts#</div>
            <div class="tile-label">Total Attempts</div>
        </div>
    </div>
</div>

<div class="row g-4">
    <!--- Command Tiles (Quick Management) --->
    <div class="col-lg-4">
        <div class="dk-card h-100" style="animation-delay:0.5s;padding:24px">
            <div class="d-flex align-items-center justify-content-between mb-4">
                <h6 style="font-weight:800;color:##fff;margin:0;display:flex;align-items:center;gap:10px">
                    <i class="fas fa-grid-2" style="color:var(--sky-blue)"></i> Command Center
                </h6>
                <div style="font-size:10px;color:rgba(148,163,184,0.4);letter-spacing:1px;font-weight:700">QUICK ACTIONS</div>
            </div>
            
            <div class="row g-3">
                <div class="col-6">
                    <a href="#event.buildLink('admin/questions')#" class="dk-tile" style="padding:15px 10px">
                        <div class="tile-emoji">🧩</div>
                        <div class="tile-label">Questions</div>
                    </a>
                </div>
                <div class="col-6">
                    <a href="#event.buildLink('admin/categories')#" class="dk-tile" style="padding:15px 10px">
                        <div class="tile-emoji">🏷️</div>
                        <div class="tile-label">Categories</div>
                    </a>
                </div>
                <div class="col-6">
                    <a href="#event.buildLink('admin/users')#" class="dk-tile" style="padding:15px 10px">
                        <div class="tile-emoji">🛡️</div>
                        <div class="tile-label">Users</div>
                    </a>
                </div>
                <div class="col-6">
                    <a href="#event.buildLink('admin/settings')#" class="dk-tile opacity-50 pe-none" style="padding:15px 10px">
                        <div class="tile-emoji">⚙️</div>
                        <div class="tile-label">Settings</div>
                    </a>
                </div>
            </div>

            <div class="mt-4 pt-4 border-top" style="border-color:rgba(148,163,184,0.05) !important">
                <div style="font-size:12px;color:var(--text-muted);display:flex;align-items:center;gap:8px">
                    <i class="fas fa-circle-info"></i>
                    <span>Drag items to reorder tiles</span>
                </div>
            </div>
        </div>
    </div>

    <!--- Mission Archive (Recent Activity) --->
    <div class="col-lg-8">
        <div class="dk-card elite mb-4" style="animation-delay:0.6s;padding:0;overflow:hidden">
            <div style="padding:22px 24px;border-bottom:1px solid rgba(148,163,184,0.05);display:flex;justify-content:space-between;align-items:center">
                <div style="font-weight:900;font-size:12px;color:rgba(148,163,184,0.6);letter-spacing:1px;text-transform:uppercase">
                    <i class="fas fa-folder-open me-2" style="color:var(--sky-blue)"></i> 
                    Recent Activity Log
                </div>
                <div class="dk-badge slate" style="font-size:10px;letter-spacing:0.5px">GLOBAL ACTIVITY</div>
            </div>
            <div class="table-responsive">
                <table class="table table-dark mb-0" style="--bs-table-bg:transparent">
                    <thead>
                        <tr style="font-size:10px;text-transform:uppercase;letter-spacing:1px;color:rgba(148,163,184,0.4)">
                            <th class="ps-4">Operative</th>
                            <th>Objective</th>
                            <th>Precision</th>
                            <th>Timestamp</th>
                            <th class="pe-4 text-end">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <cfloop query="prc.stats.recentAttempts">
                        <tr style="transition:all 0.3s;border-color:rgba(148,163,184,0.03)" onmouseover="this.style.background='rgba(56,189,248,0.02)'" onmouseout="this.style.background='transparent'">
                            <td class="ps-4 py-3">
                                <div class="d-flex align-items-center gap-3">
                                    <div style="width:30px;height:30px;background:var(--sky-blue);border-radius:8px;color:##000;font-size:12px;display:flex;align-items:center;justify-content:center;font-weight:900">
                                        #ucase(left(username,1))#
                                    </div>
                                    <span style="font-weight:700;color:##fff">#username#</span>
                                </div>
                            </td>
                            <td style="font-size:14px;color:rgba(148,163,184,0.9)">#test_title#</td>
                            <td>
                                <div style="font-weight:800;color:<cfif percentage GTE 70>##22c55e<cfelseif percentage GTE 40>##fbbf24<cfelse>##ef4444</cfif>">
                                    #numberFormat(percentage, "0")#%
                                </div>
                            </td>
                            <td style="font-size:11px;color:rgba(148,163,184,0.5);font-weight:600">
                                #dateFormat(finished_at, "MMM d")# <span style="opacity:0.4">/</span> #timeFormat(finished_at, "HH:nn")#
                            </td>
                            <td class="text-end pe-4">
                                <span class="dk-badge <cfif percentage GTE 70>green<cfelse>slate</cfif>" style="font-size:10px;font-weight:800;letter-spacing:0.5px">
                                    <cfif percentage GTE 70>SUCCESS<cfelse>RESOLVED</cfif>
                                </span>
                            </td>
                        </tr>
                        </cfloop>
                        <cfif NOT prc.stats.recentAttempts.recordCount>
                        <tr>
                            <td colspan="5" class="text-center py-5 text-muted">
                                <div class="tile-emoji" style="font-size:32px;opacity:0.2">🗄️</div>
                                <p style="font-size:12px;margin-top:10px">Archive is currently empty.</p>
                            </td>
                        </tr>
                        </cfif>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

</cfoutput>

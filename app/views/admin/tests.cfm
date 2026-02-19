<cfoutput>
<div class="page-header">
    <h1 class="page-title">Mission Control — Tests</h1>
    <p class="page-desc">Manage the roster of available missions and practice simulations</p>
</div>

<div class="d-flex justify-content-between align-items-end mb-4" style="animation:fadeSlideUp 0.3s ease both">
    <div class="d-flex gap-4">
        <div class="dk-stat-mini">
            <div class="stat-label">Tactical Missions</div>
            <div class="stat-value">#prc.tests.recordCount#</div>
        </div>
        <div class="dk-stat-mini">
            <div class="stat-label">Practice Simulations</div>
            <div class="stat-value">#prc.practiceTests.recordCount#</div>
        </div>
    </div>
    <a href="#event.buildLink('admin/createTest')#" class="dk-btn sky">
        <i class="fas fa-plus"></i> Deploy New Mission
    </a>
</div>

<!--- Tactical Missions (Real Tests) --->
<h6 class="mb-3 mt-4" style="color:var(--sky-blue);font-weight:800;font-size:11px;text-transform:uppercase;letter-spacing:2px">
    <i class="fas fa-crosshairs me-2"></i> Tactical Missions
</h6>
<div class="dk-table-wrap mb-5">
    <table class="table">
        <thead>
            <tr>
                <th class="ps-4">Title</th>
                <th>Category</th>
                <th>Difficulty</th>
                <th>Intel Count</th>
                <th>Time Limit</th>
                <th>Status</th>
                <th class="pe-4 text-end">Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="prc.tests">
                <tr style="transition:all 0.3s" onmouseover="this.style.background='rgba(56,189,248,0.02)'" onmouseout="this.style.background='transparent'">
                    <td class="ps-4 py-3">
                        <div style="font-weight:700;color:##fff;font-size:14px">#title#</div>
                        <div style="color:rgba(148,163,184,0.5);font-size:11px;max-width:250px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis">#description#</div>
                    </td>
                    <td><span class="dk-badge" style="background:rgba(56,189,248,0.1);color:var(--sky-blue)">#category_name#</span></td>
                    <td><span class="dk-badge" style="background:rgba(251,191,36,0.1);color:##fbbf24">#difficulty_name#</span></td>
                    <td style="color:##cbd5e1;font-weight:600">#total_questions# Qs</td>
                    <td style="color:rgba(148,163,184,0.7);font-size:13px">#time_minutes# Mins</td>
                    <td>
                        <span class="dk-badge <cfif is_active>green<cfelse>red</cfif>" style="font-size:10px;font-weight:800">
                            <i class="fas fa-circle me-1" style="font-size:6px;vertical-align:middle"></i>
                            <cfif is_active>ACTIVE<cfelse>ARCHIVED</cfif>
                        </span>
                    </td>
                    <td class="pe-4 py-3 text-end">
                        <div class="d-flex gap-1 justify-content-end">
                            <a href="#event.buildLink('admin/editTest')#?testId=#id#" class="dk-btn-icon" title="Edit Parameters">
                                <span style="font-size:14px">📝</span>
                            </a>
                            <button class="bg-transparent border-0 p-0 ms-2"
                                    onclick="confirmDelete('Archive this mission?', '#event.buildLink('admin/deleteTest')#?testId=#id#')" title="Archive Test" style="cursor:pointer">
                                <span style="font-size:14px">🗑️</span>
                            </button>
                        </div>
                    </td>
                </tr>
            </cfloop>
            <cfif NOT prc.tests.recordCount>
                <tr><td colspan="7" class="text-center py-5" style="color:rgba(148,163,184,0.4)">No tactical missions deployed.</td></tr>
            </cfif>
        </tbody>
    </table>
</div>

<!--- Practice Simulations --->
<h6 class="mb-3 mt-4" style="color:##22c55e;font-weight:800;font-size:11px;text-transform:uppercase;letter-spacing:2px">
    <i class="fas fa-dumbbell me-2"></i> Practice Simulations
</h6>
<div class="dk-table-wrap">
    <table class="table">
        <thead>
            <tr>
                <th class="ps-4">Simulation Title</th>
                <th>Intelligence Unit</th>
                <th>Complexity</th>
                <th>Volume</th>
                <th>Status</th>
                <th class="pe-4 text-end">Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="prc.practiceTests">
                <tr style="transition:all 0.3s" onmouseover="this.style.background='rgba(34,197,94,0.02)'" onmouseout="this.style.background='transparent'">
                    <td class="ps-4 py-3">
                        <div style="font-weight:700;color:##fff;font-size:14px">#title#</div>
                        <div style="color:rgba(148,163,184,0.5);font-size:11px">#description#</div>
                    </td>
                    <td><span class="dk-badge green">#category_name#</span></td>
                    <td><span class="dk-badge slate">#difficulty_name#</span></td>
                    <td style="color:##cbd5e1;font-weight:600">#total_questions# Qs</td>
                    <td>
                        <span class="dk-badge <cfif is_active>green<cfelse>red</cfif>" style="font-size:10px;font-weight:800">
                            <i class="fas fa-circle me-1" style="font-size:6px;vertical-align:middle"></i>
                            <cfif is_active>OPERATIONAL<cfelse>OFFLINE</cfif>
                        </span>
                    </td>
                    <td class="pe-4 py-3 text-end">
                        <div class="d-flex gap-1 justify-content-end">
                            <a href="#event.buildLink('admin/editTest')#?testId=#id#" class="dk-btn-icon" title="Edit Parameters">
                                <span style="font-size:14px">📝</span>
                            </a>
                            <button class="bg-transparent border-0 p-0 ms-2"
                                    onclick="confirmDelete('Shutdown this simulation?', '#event.buildLink('admin/deleteTest')#?testId=#id#')" title="Archive Test" style="cursor:pointer">
                                <span style="font-size:14px">🗑️</span>
                            </button>
                        </div>
                    </td>
                </tr>
            </cfloop>
            <cfif NOT prc.practiceTests.recordCount>
                <tr><td colspan="6" class="text-center py-5" style="color:rgba(148,163,184,0.4)">No practice simulations active.</td></tr>
            </cfif>
        </tbody>
    </table>
</div>

<style>
.dk-stat-mini {
    background: rgba(15, 23, 42, 0.4);
    border: 1px solid rgba(148, 163, 184, 0.1);
    border-radius: 10px;
    padding: 10px 16px;
}
.dk-stat-mini .stat-label {
    font-size: 9px;
    font-weight: 800;
    color: rgba(148, 163, 184, 0.5);
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 2px;
}
.dk-stat-mini .stat-value {
    font-size: 18px;
    font-weight: 800;
    color: ##fff;
}
</style>
</cfoutput>

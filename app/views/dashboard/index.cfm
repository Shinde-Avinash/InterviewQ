<cfoutput>
<div class="container container-dark pb-5">
    <div class="page-header" style="animation:fadeSlideUp 0.4s ease both">
        <h1 class="page-title">Dashboard</h1>
        <p class="page-desc">Welcome back, #session.user.firstName ?: session.username#. Here's your performance overview.</p>
    </div>

    <!--- Elite Stat Tiles --->
    <div class="row g-3 mb-5">
        <div class="col-md-3">
            <div class="dk-tile" style="animation-delay:0.05s">
                <div class="tile-emoji">📑</div>
                <div class="stat-value">#prc.stats.testsTaken#</div>
                <div class="tile-label">Missions Done</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="dk-tile" style="animation-delay:0.1s">
                <div class="tile-emoji">🎯</div>
                <div class="stat-value">#prc.stats.avgScore#<small style="font-size:14px;opacity:0.6">%</small></div>
                <div class="tile-label">Precision Rate</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="dk-tile" style="animation-delay:0.15s">
                <div class="tile-emoji">💎</div>
                <div class="stat-value">#prc.stats.accuracyPct#<small style="font-size:14px;opacity:0.6">%</small></div>
                <div class="tile-label">Stability Index</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="dk-tile" style="animation-delay:0.2s">
                <div class="tile-emoji">✅</div>
                <div class="stat-value">#prc.stats.totalCorrect#</div>
                <div class="tile-label">Total Resolves</div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!--- Left col --->
        <div class="col-lg-8">
            <!--- Chart --->
            <div class="dk-card mb-4" style="animation-delay:0.25s">
                <div style="font-weight:700;font-size:14px;margin-bottom:20px;color:##fff;display:flex;align-items:center;gap:8px">
                    <i class="fas fa-chart-bar" style="color:var(--sky-blue)"></i> 
                    Category Performance
                </div>
                <canvas id="categoryChart" height="220"></canvas>
            </div>

            <!--- Intel Stream (Recent tests) --->
            <div class="dk-card elite mb-4" style="animation-delay:0.3s;padding:0;overflow:hidden">
                <div style="padding:22px 24px;border-bottom:1px solid rgba(148,163,184,0.05);display:flex;align-items:center;justify-content:between">
                    <div style="font-weight:900;font-size:12px;color:rgba(148,163,184,0.6);letter-spacing:1px;text-transform:uppercase">
                        <i class="fas fa-satellite-dish me-2" style="color:var(--sky-blue)"></i> 
                        Intelligence Stream
                    </div>
                </div>
                <cfif prc.stats.recentTests.recordCount>
                    <div class="table-responsive">
                        <table class="table table-dark mb-0" style="--bs-table-bg:transparent">
                            <thead>
                                <tr style="font-size:10px;text-transform:uppercase;letter-spacing:1px;color:rgba(148,163,184,0.4)">
                                    <th class="ps-4">Mission</th>
                                    <th>Sector</th>
                                    <th>Yield</th>
                                    <th class="pe-4 text-end">Timestamp</th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop query="prc.stats.recentTests">
                                <tr style="transition:all 0.3s;border-color:rgba(148,163,184,0.03)" onmouseover="this.style.background='rgba(56,189,248,0.02)'" onmouseout="this.style.background='transparent'">
                                    <td class="ps-4 py-3">
                                        <div class="d-flex align-items-center gap-3">
                                            <div style="width:34px;height:34px;background:rgba(56,189,248,0.08);border-radius:10px;display:flex;align-items:center;justify-content:center;font-size:16px">
                                                <cfif category_name CONTAINS "ColdFusion">🧪<cfelseif category_name CONTAINS "JS" OR category_name CONTAINS "Java">⚡<cfelseif category_name CONTAINS "SQL">📑<cfelse>🔋</cfif>
                                            </div>
                                            <div style="font-weight:700;color:##fff;font-size:14px">#test_title#</div>
                                        </div>
                                    </td>
                                    <td><span class="dk-badge slate" style="font-family:monospace;font-size:10px">#ucase(category_name)#</span></td>
                                    <td>
                                        <div style="font-weight:900;font-size:16px;color:<cfif percentage GTE 70>##22c55e<cfelseif percentage GTE 40>##fbbf24<cfelse>##ef4444</cfif>">
                                            #numberFormat(percentage, "0")#<small style="font-size:11px;opacity:0.6">%</small>
                                        </div>
                                    </td>
                                    <td class="pe-4 py-3 text-end" style="color:rgba(148,163,184,0.6);font-size:11px;font-weight:600">
                                        #dateFormat(finished_at, "dd MMM")# <span style="opacity:0.4">/</span> #timeFormat(finished_at, "HH:nn")#
                                    </td>
                                </tr>
                                </cfloop>
                            </tbody>
                        </table>
                    </div>
                <cfelse>
                    <div class="text-center py-5" style="color:var(--text-muted)">
                        <div class="tile-emoji" style="font-size:40px;opacity:0.1">📡</div>
                        <p style="font-size:13px;margin-top:10px">No intelligence units detected. <a href="#event.buildLink('test')#" style="color:var(--sky-blue)">Open Comm Link</a></p>
                    </div>
                </cfif>
            </div>
        </div>

        <!--- Right col --->
        <div class="col-lg-4">
            <!--- Rank --->
            <div class="dk-card elite mb-4" style="animation-delay:0.35s;padding:28px">
                <div class="d-flex align-items-center justify-content-between mb-3">
                    <div style="font-weight:800;font-size:12px;color:rgba(148,163,184,0.6);letter-spacing:1px">ELITE STANDING</div>
                    <div class="tile-emoji" style="font-size:20px">🏆</div>
                </div>
                <div class="text-center py-2">
                    <div style="font-size:48px;font-weight:900;color:##fff;letter-spacing:-2px;filter:drop-shadow(0 0 20px rgba(56,189,248,0.3))">
                        ##<cfif prc.stats.rank.rank_position GT 0>#prc.stats.rank.rank_position#<cfelse>--</cfif>
                    </div>
                    <div style="font-size:12px;color:var(--sky-blue);font-weight:700;margin-top:8px;text-transform:uppercase;letter-spacing:1px">
                         Global Rank &middot; #numberFormat(prc.stats.rank.avg_percentage, "0")#% Mastery
                    </div>
                </div>
            </div>

            <!--- Mission Control (Quick actions) --->
            <div class="dk-card mb-4" style="animation-delay:0.4s">
                <div style="font-weight:800;font-size:12px;margin-bottom:20px;color:rgba(148,163,184,0.6);letter-spacing:1px">MISSION CONTROL</div>
                <div class="row g-3">
                    <div class="col-6">
                        <a href="#event.buildLink('test')#" class="dk-tile" style="padding:15px 10px">
                            <div class="tile-emoji">🚀</div>
                            <div class="tile-label">Launch</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="#event.buildLink('practice')#" class="dk-tile" style="padding:15px 10px">
                            <div class="tile-emoji">🧪</div>
                            <div class="tile-label">Lab</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="#event.buildLink('leaderboard')#" class="dk-tile" style="padding:15px 10px">
                            <div class="tile-emoji">📡</div>
                            <div class="tile-label">Radar</div>
                        </a>
                    </div>
                    <div class="col-6">
                        <a href="##" class="dk-tile opacity-50 pe-none" style="padding:15px 10px">
                            <div class="tile-emoji">💾</div>
                            <div class="tile-label">Vault</div>
                        </a>
                    </div>
                </div>
            </div>

            <!--- Focus Sectors --->
            <div class="dk-card" style="animation-delay:0.45s">
                <div style="font-weight:800;font-size:12px;margin-bottom:20px;color:rgba(148,163,184,0.6);letter-spacing:1px;display:flex;align-items:center;justify-content:between">
                    <span>FOCUS SECTORS</span>
                    <span class="tile-emoji" style="font-size:14px">🧩</span>
                </div>
                <cfset weakAreas = prc.stats.categoryPerf>
                <cfif weakAreas.recordCount>
                    <cfloop query="weakAreas">
                    <div style="margin-bottom:16px">
                        <div class="d-flex justify-content-between" style="font-size:12px;margin-bottom:6px">
                            <span style="font-weight:600;color:##e2e8f0">#category_name#</span>
                            <span style="color:var(--text-muted)">#numberFormat(avg_pct, "0.0")#%</span>
                        </div>
                        <div class="dk-progress-bar">
                            <div class="dk-progress-fill" style="width:#avg_pct#%;background:<cfif avg_pct GTE 70>##22c55e<cfelseif avg_pct GTE 40>##fbbf24<cfelse>##ef4444</cfif>;box-shadow: 0 0 10px rgba(56,189,248,0.1)"></div>
                        </div>
                    </div>
                    </cfloop>
                <cfelse>
                    <p style="font-size:12px;color:var(--text-muted);margin:0">Complete more tests to see your skill breakdown.</p>
                </cfif>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var ctx = document.getElementById('categoryChart');
    if (!ctx) return;

    <cfset catLabels = []>
    <cfset catValues = []>
    <cfloop query="prc.stats.categoryPerf">
        <cfset arrayAppend(catLabels, '"#jsStringFormat(category_name)#"')>
        <cfset arrayAppend(catValues, numberFormat(avg_pct, "0.0"))>
    </cfloop>

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: [#arrayToList(catLabels)#],
            datasets: [{
                label: 'Score %',
                data: [#arrayToList(catValues)#],
                backgroundColor: 'rgba(56, 189, 248, 0.7)',
                borderColor: '##38bdf8',
                borderWidth: 1,
                borderRadius: 6,
                hoverBackgroundColor: '##38bdf8'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: 'rgba(15, 23, 42, 0.9)',
                    titleColor: '##fff',
                    bodyColor: '##38bdf8',
                    borderColor: 'rgba(56, 189, 248, 0.2)',
                    borderWidth: 1,
                    padding: 10,
                    bodyFont: { family: 'Inter', weight: 'bold' }
                }
            },
            scales: {
                y: { 
                    beginAtZero: true, 
                    max: 100, 
                    grid: { color: 'rgba(148, 163, 184, 0.1)' },
                    ticks: { color: '##64748b', font: { size: 10 } }
                },
                x: { 
                    grid: { display: false },
                    ticks: { color: '##64748b', font: { size: 10 } }
                }
            }
        }
    });
});
</script>
</cfoutput>

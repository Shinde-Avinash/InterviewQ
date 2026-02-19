<cfoutput>
<div class="container container-dark pb-5">
    <div class="page-header text-center" style="animation:fadeSlideUp 0.4s ease both">
        <h1 class="page-title">Global Leaderboard</h1>
        <p class="page-desc">Top performers making waves on the platform.</p>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-7">
            <div class="dk-card elite" style="padding:15px;animation-delay:0.1s">
                <cfif prc.leaderboard.recordCount>
                    <cfloop query="prc.leaderboard">
                        <div class="d-flex align-items-center gap-3 p-3 mb-2" style="background:rgba(15, 23, 42, 0.3);border:1px solid rgba(56, 189, 248, 0.05);border-radius:16px;animation:fadeSlideUp 0.4s ease both;animation-delay:#(currentRow * 0.05)#s;transition:all 0.3s" onmouseover="this.style.background='rgba(56,189,248,0.05)';this.style.borderColor='rgba(56,189,248,0.2)'" onmouseout="this.style.background='rgba(15, 23, 42, 0.3)';this.style.borderColor='rgba(56,189,248,0.05)'">
                            <div class="d-flex align-items-center justify-content-center" style="width:40px;height:40px;border-radius:12px;font-weight:900;font-size:16px;
                                <cfif currentRow EQ 1>background:linear-gradient(135deg, ##fbbf24, ##d97706);color:##000;box-shadow:0 0 15px rgba(251,191,36,0.4)
                                <cfelseif currentRow EQ 2>background:linear-gradient(135deg, ##cbd5e1, ##94a3b8);color:##000;box-shadow:0 0 15px rgba(203,213,225,0.4)
                                <cfelseif currentRow EQ 3>background:linear-gradient(135deg, ##d97706, ##92400e);color:##000;box-shadow:0 0 15px rgba(217,119,6,0.4)
                                <cfelse>background:rgba(30,41,59,0.5);color:rgba(148,163,184,0.8);border:1px solid rgba(148,163,184,0.1)
                                </cfif>">
                                <cfif currentRow EQ 1>🥇<cfelseif currentRow EQ 2>🥈<cfelseif currentRow EQ 3>🥉<cfelse>#currentRow#</cfif>
                            </div>
                            <div class="dk-avatar" style="width:42px;height:42px;font-size:16px;font-weight:800;border:2px solid rgba(56,189,248,0.1)">#uCase(left(username, 1))#</div>
                            <div class="flex-grow-1">
                                <div style="font-weight:800;font-size:16px;color:##fff;letter-spacing:-0.2px">#username#</div>
                                <div style="color:rgba(148,163,184,0.6);font-size:11px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px">#tests_taken# Missions &middot; <span style="color:var(--sky-blue)">ACTIVE</span></div>
                            </div>
                            <div class="text-end">
                                <div style="font-weight:900;font-size:20px;color:var(--sky-blue);line-height:1;filter:drop-shadow(0 0 10px rgba(56,189,248,0.2))">#numberFormat(avg_percentage, "0.0")#<small style="font-size:12px;opacity:0.6">%</small></div>
                                <div style="font-size:9px;color:rgba(148,163,184,0.4);font-weight:800;text-transform:uppercase;letter-spacing:1px;margin-top:4px">Mastery Index</div>
                            </div>
                        </div>
                    </cfloop>
                <cfelse>
                    <div class="text-center py-5" style="color:var(--text-muted)">
                        <i class="fas fa-trophy fa-3x mb-3 opacity-20"></i>
                        <p style="font-size:14px">No competition data yet. Be the first to claim the top spot!</p>
                        <a href="#event.buildLink('test')#" class="dk-btn sky mt-3">Start a Test</a>
                    </div>
                </cfif>
            </div>
        </div>
    </div>
</div>
</cfoutput>

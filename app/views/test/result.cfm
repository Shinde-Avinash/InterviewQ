<cfoutput>
<div class="container py-2 pb-5">
    <div class="text-center mb-5" style="animation:fadeSlideUp 0.5s ease both">
        <cfif prc.resultData.attempt.recordCount>
            <cfset att = prc.resultData.attempt>
            <cfset pct = att.percentage>

            <div style="width:160px;height:160px;margin:0 auto 24px;border-radius:50%;display:flex;flex-direction:column;align-items:center;justify-content:center;
                background:rgba(15,23,42,0.8);border:4px solid <cfif pct GTE 70>##22c55e<cfelseif pct GTE 40>##fbbf24<cfelse>##ef4444</cfif>;
                box-shadow: 0 0 40px <cfif pct GTE 70>rgba(34,197,94,0.3)<cfelseif pct GTE 40>rgba(251,191,36,0.3)<cfelse>rgba(239,68,68,0.3)</cfif>;
                backdrop-filter:blur(12px)">
                <div style="font-size:42px;font-weight:900;color:##fff;line-height:1;letter-spacing:-1px">#numberFormat(pct, "0")#%</div>
                <div style="font-size:11px;color:var(--text-muted);text-transform:uppercase;font-weight:800;letter-spacing:1.5px;margin-top:4px">Accuracy</div>
            </div>

            <h2 style="font-weight:900;color:##fff;margin-bottom:10px;font-size:28px;letter-spacing:-0.5px">#att.test_title#</h2>
            <p style="color:var(--text-muted);font-size:14px;max-width:550px;margin:0 auto;line-height:1.6">
                <cfif pct GTE 80>Outstanding Performance! You've demonstrated exceptional technical mastery in this field.
                <cfelseif pct GTE 60>Great results! You have a solid grasp of the core concepts. Keep refining your skills.
                <cfelseif pct GTE 40>Standard effort. Review the tactical data below to identify areas for improvement.
                <cfelse>Mission Failed. But every failure is a goldmine of data. Analyze and re-engage.
                </cfif>
            </p>

            <div class="d-flex justify-content-center gap-3 mt-5">
                <div class="dk-stat" style="min-width:120px;padding:20px 15px;background:rgba(34,197,94,0.05);border-color:rgba(34,197,94,0.1)">
                    <div class="stat-value" style="color:##22c55e;font-size:28px;font-weight:900">#att.correct_answers#</div>
                    <div class="stat-label" style="font-size:10px">Correct</div>
                </div>
                <div class="dk-stat" style="min-width:120px;padding:20px 15px;background:rgba(239,68,68,0.05);border-color:rgba(239,68,68,0.1)">
                    <div class="stat-value" style="color:##ef4444;font-size:28px;font-weight:900">#att.wrong_answers#</div>
                    <div class="stat-label" style="font-size:10px">Incorrect</div>
                </div>
                <div class="dk-stat" style="min-width:120px;padding:20px 15px;background:rgba(148,163,184,0.05);border-color:rgba(148,163,184,0.1)">
                    <div class="stat-value" style="color:var(--text-muted);font-size:28px;font-weight:900">#att.unanswered#</div>
                    <div class="stat-label" style="font-size:10px">Skipped</div>
                </div>
                <div class="dk-stat" style="min-width:120px;padding:20px 15px;background:rgba(56,189,248,0.05);border-color:rgba(56,189,248,0.1)">
                    <div class="stat-value" style="color:var(--sky-blue);font-size:28px;font-weight:900">#numberFormat(att.score, "0.0")#</div>
                    <div class="stat-label" style="font-size:10px">Final Score</div>
                </div>
            </div>
        </cfif>
    </div>

    <!--- Answer Review --->
    <div style="max-width:900px;margin:0 auto">
        <h4 style="font-weight:800;margin-bottom:24px;color:##fff;display:flex;align-items:center;gap:12px">
            <i class="fas fa-list-check" style="color:var(--sky-blue)"></i> Detailed Analysis
        </h4>

        <cfif prc.resultData.answers.recordCount>
            <cfset qNum = 1>
            <cfset currentQId = 0>
            <cfloop query="prc.resultData.answers">
                <cfif prc.resultData.answers.question_id NEQ currentQId>
                    <cfif currentQId NEQ 0></div></div></cfif>
                    <cfset currentQId = prc.resultData.answers.question_id>
                    <div class="dk-card mb-4" style="animation-delay:#(qNum * 0.05)#s">
                        <div class="d-flex gap-2 mb-3">
                            <span class="dk-badge <cfif prc.resultData.answers.answer_is_correct>green<cfelse>red</cfif>">
                                <i class="fas <cfif prc.resultData.answers.answer_is_correct>fa-check<cfelse>fa-times</cfif> me-1"></i>
                                <cfif prc.resultData.answers.answer_is_correct>Correct<cfelse>Incorrect</cfif>
                            </span>
                            <span class="dk-badge slate">#prc.resultData.answers.test_category_name#</span>
                        </div>
                        <div style="font-weight:700;font-size:16px;color:##fff;margin-bottom:20px;line-height:1.5">
                            <span style="color:var(--sky-blue);margin-right:8px">Q#qNum#.</span> #encodeForHTML(prc.resultData.answers.question_text)#
                        </div>
                        <cfset qNum++>

                        <cfif len(prc.resultData.answers.code_snippet)>
                            <pre class="mb-4" style="background:rgba(15,23,42,0.8);border:1px solid rgba(148,163,184,0.1);border-radius:10px;padding:16px"><code class="language-javascript">#encodeForHTML(prc.resultData.answers.code_snippet)#</code></pre>
                        </cfif>

                        <div class="d-grid gap-2">
                </cfif>

                <div class="d-flex align-items-center gap-3 p-3" style="border-radius:10px;border:1px solid <cfif prc.resultData.answers.option_id EQ prc.resultData.answers.selected_option_id AND prc.resultData.answers.option_is_correct>rgba(34,197,94,0.3)<cfelseif prc.resultData.answers.option_id EQ prc.resultData.answers.selected_option_id>rgba(239,68,68,0.3)<cfelseif prc.resultData.answers.option_is_correct>rgba(34,197,94,0.2)<cfelse>rgba(148,163,184,0.1)</cfif>;
                    background:<cfif prc.resultData.answers.option_id EQ prc.resultData.answers.selected_option_id AND prc.resultData.answers.option_is_correct>rgba(34,197,94,0.1)<cfelseif prc.resultData.answers.option_id EQ prc.resultData.answers.selected_option_id>rgba(239,68,68,0.1)<cfelseif prc.resultData.answers.option_is_correct>rgba(34,197,94,0.05)<cfelse>rgba(15,23,42,0.4)</cfif>">
                    
                    <div class="d-flex align-items-center justify-content-center" style="width:28px;height:28px;border-radius:6px;font-weight:700;font-size:12px;
                        <cfif prc.resultData.answers.option_is_correct>background:##22c55e;color:##0a0e1a<cfelse>background:rgba(148,163,184,0.1);color:var(--text-muted)</cfif>">
                        #chr(64 + prc.resultData.answers.sort_order)#
                    </div>
                    
                    <div class="flex-grow-1" style="font-size:14px;color:<cfif prc.resultData.answers.option_is_correct>##fff<cfelse>var(--text-white)</cfif>">#encodeForHTML(prc.resultData.answers.option_text)#</div>
                    
                    <cfif prc.resultData.answers.option_id EQ prc.resultData.answers.selected_option_id>
                        <i class="fas <cfif prc.resultData.answers.option_is_correct>fa-check-circle<cfelse>fa-times-circle</cfif>" style="color:<cfif prc.resultData.answers.option_is_correct>##22c55e<cfelse>##ef4444</cfif>" title="Your Choice"></i>
                    <cfelseif prc.resultData.answers.option_is_correct>
                        <i class="fas fa-check" style="color:##22c55e;opacity:0.5" title="Correct Answer"></i>
                    </cfif>
                </div>
            </cfloop>
            <cfif currentQId NEQ 0>
                </div>
                <cfif len(prc.resultData.answers.explanation)>
                    <div style="margin-top:20px;padding:16px;background:rgba(56,189,248,0.06);border-left:3px solid var(--sky-blue);border-radius:4px 10px 10px 4px;font-size:13px">
                        <strong style="color:var(--sky-blue);display:block;margin-bottom:6px"><i class="fas fa-lightbulb me-1"></i> Explanation:</strong>
                        <span style="color:rgba(255,255,255,0.7);line-height:1.6">#encodeForHTML(prc.resultData.answers.explanation)#</span>
                    </div>
                </cfif>
                </div>
            </cfif>
        </cfif>
    </div>

    <div class="text-center mt-5 mb-5" style="animation:fadeSlideUp 0.6s ease both">
        <a href="#event.buildLink('test')#" class="dk-btn sky me-3" style="padding:12px 32px"><i class="fas fa-redo me-2"></i> Take Another Test</a>
        <a href="#event.buildLink('dashboard')#" class="dk-btn ghost" style="padding:12px 32px"><i class="fas fa-chart-line me-2"></i> Back to Dashboard</a>
    </div>
</div>
</cfoutput>

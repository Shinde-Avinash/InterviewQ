<cfoutput>
<!--- Test Taking Engine --->
<div class="container-fluid py-2">
    <div class="row g-4">
        <!--- Main Question Area --->
        <div class="col-lg-9">
            <!--- Header Card --->
            <div class="dk-card mb-4" style="padding:15px 24px;border-color:rgba(56,189,248,0.2);display:flex;justify-content:space-between;align-items:center;background:linear-gradient(135deg, rgba(15,23,42,0.6), rgba(10,14,30,0.4)) !important">
                <div class="ps-1">
                    <h5 style="font-weight:900;margin:0;color:##fff;letter-spacing:-0.5px;font-size:18px">#prc.attempt.test_title#</h5>
                    <span id="questionCounter" style="color:var(--text-muted);font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.5px">Question 1 of #prc.questions.recordCount#</span>
                </div>
                <div class="d-flex align-items-center gap-4">
                    <div id="timer" class="timer-display" style="background:rgba(239,68,68,0.1);color:##ef4444;padding:6px 16px;border-radius:10px;font-weight:800;font-size:20px;font-family:'JetBrains Mono',monospace;border:1px solid rgba(239,68,68,0.2);box-shadow:0 0 15px rgba(239,68,68,0.1)">
                        #numberFormat(prc.attemptDuration,"00")#:00
                    </div>
                    <button class="dk-btn ghost" onclick="showReviewModal()" style="padding:8px 18px;font-size:12px;font-weight:800;text-transform:uppercase;letter-spacing:0.5px">
                        <i class="fas fa-flag-checkered me-2"></i>Review & Submit
                    </button>
                </div>
            </div>

            <!--- Questions --->
            <cfset qIndex = 0>
            <cfloop query="prc.questions">
                <div id="question-#qIndex#" class="question-slide" style="display:none;animation:fadeSlideUp 0.4s ease both">
                    <div class="dk-card" style="padding:32px;min-height:420px;display:flex;flex-direction:column;border-color:rgba(148,163,184,0.1)">
                        <div class="d-flex justify-content-between align-items-start mb-4">
                            <div style="font-size:20px;font-weight:700;color:##fff;line-height:1.5;flex:1">#encodeForHTML(question_text)#</div>
                            <button class="btn btn-sm border-0 bookmark-btn <cfif is_bookmarked>text-warning</cfif> ms-3"
                                    onclick="toggleBookmark(#question_id#, this)" title="Bookmark" style="padding:10px;border-radius:12px;background:rgba(148,163,184,0.05);transition:all 0.2s">
                                <i class="fas fa-bookmark fa-lg"></i>
                            </button>
                        </div>

                        <cfif len(code_snippet)>
                            <pre class="mb-5 custom-scrollbar" style="background:rgba(10,14,30,0.6);border:1px solid rgba(148,163,184,0.1);border-radius:12px;padding:20px;font-size:14px;max-height:300px;overflow:auto"><code class="language-javascript">#encodeForHTML(code_snippet)#</code></pre>
                        </cfif>

                        <div class="mt-auto">
                            <cfset optQuery = prc.allOptions[question_id]>
                            <cfset optLetters = ["A","B","C","D","E","F"]>
                            <cfset optIdx = 1>
                            <div class="d-grid gap-3 options-group">
                                <cfloop query="optQuery">
                                    <div class="dk-option <cfif optQuery.id EQ prc.questions.selected_option_id>selected</cfif>"
                                         onclick="selectOption(#prc.questions.question_id#, #optQuery.id#, this)"
                                         style="padding:16px 20px;background:rgba(30,41,59,0.2);border:1px solid rgba(148,163,184,0.1);border-radius:12px;cursor:pointer;transition:all 0.2s;display:flex;align-items:center;gap:15px">
                                        <div class="opt-letter" style="width:32px;height:32px;border-radius:8px;background:rgba(148,163,184,0.05);display:flex;align-items:center;justify-content:center;font-weight:800;font-size:14px;color:rgba(255,255,255,0.4)">#optLetters[optIdx]#</div>
                                        <div class="opt-text" style="font-size:15px;color:rgba(255,255,255,0.8);font-weight:500">#encodeForHTML(optQuery.option_text)#</div>
                                    </div>
                                    <cfset optIdx++>
                                </cfloop>
                            </div>
                        </div>
                    </div>
                </div>
                <cfset qIndex++>
            </cfloop>

            <!--- Navigation --->
            <div class="d-flex justify-content-between mt-4">
                <button id="prevBtn" class="dk-btn ghost" onclick="prevQuestion()" style="padding:12px 28px;font-weight:800;text-transform:uppercase;letter-spacing:0.5px">
                    <i class="fas fa-arrow-left me-2"></i> Previous
                </button>
                <div class="d-flex gap-3">
                    <button id="nextBtn" class="dk-btn sky" onclick="nextQuestion()" style="padding:12px 40px;font-weight:900;text-transform:uppercase;letter-spacing:1px">
                        Next <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                    <button id="submitBtn" class="dk-btn sky" style="display:none;padding:12px 40px;font-weight:900;background:##22c55e;border-color:##22c55e;text-transform:uppercase;letter-spacing:1px" onclick="submitTest()">
                        <i class="fas fa-check-double me-2"></i> Submit Mission
                    </button>
                </div>
            </div>
        </div>

        <!--- Sidebar — Palette --->
        <div class="col-lg-3">
            <div class="dk-card position-sticky" style="top:1rem;padding:24px;border-color:rgba(56,189,248,0.15)">
                <h6 style="font-weight:900;margin-bottom:24px;color:##fff;display:flex;align-items:center;gap:12px;font-size:13px;text-transform:uppercase;letter-spacing:1px">
                    <i class="fas fa-layer-group" style="color:var(--sky-blue)"></i> 
                    Mission Palette
                </h6>
                <div class="dk-palette" style="display:grid;grid-template-columns:repeat(5, 1fr);gap:8px">
                    <cfloop from="0" to="#prc.questions.recordCount - 1#" index="i">
                        <button class="palette-item <cfif i EQ 0>active</cfif>"
                                data-index="#i#" onclick="showQuestion(#i#)"
                                style="aspect-ratio:1;border-radius:10px;border:1px solid rgba(148,163,184,0.1);background:rgba(148,163,184,0.05);color:rgba(255,255,255,0.4);font-weight:800;font-size:13px;transition:all 0.2s">
                            #i + 1#
                        </button>
                    </cfloop>
                </div>

                <div class="mt-4 pt-4" style="border-top:1px solid rgba(148,163,184,0.08)">
                    <div style="font-size:11px;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.5px">
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div style="width:12px;height:12px;background:var(--sky-blue);border-radius:4px;box-shadow:0 0 10px rgba(56,189,248,0.4)"></div> 
                            <span style="font-weight:700">Answered</span>
                        </div>
                        <div class="d-flex align-items-center gap-3 mb-3">
                            <div style="width:12px;height:12px;background:##fbbf24;border-radius:4px;box-shadow:0 0 10px rgba(251,191,36,0.3)"></div> 
                            <span style="font-weight:700">Flagged</span>
                        </div>
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:12px;height:12px;background:rgba(148,163,184,0.1);border:1px solid rgba(148,163,184,0.2);border-radius:4px"></div> 
                            <span style="font-weight:700">Pending</span>
                        </div>
                    </div>
                </div>

                <cfif prc.attempt.negative_marking>
                <div style="margin-top:24px;padding:15px;background:rgba(239,68,68,0.06);border-radius:14px;font-size:11px;color:##ef4444;border:1px solid rgba(239,68,68,0.12);line-height:1.4">
                    <i class="fas fa-shield-virus me-2" style="font-size:14px"></i>
                    <strong>TACTICAL ALERT:</strong> -#numberFormat(prc.attempt.negative_mark_value,"0.00")# per invalid response.
                </div>
                </cfif>
            </div>
        </div>
    </div>
</div>

<!--- Review Modal --->
<div class="modal fade" id="reviewModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background:rgba(10,14,30,0.85);backdrop-filter:blur(25px);border:1px solid rgba(56,189,248,0.2);border-radius:32px;box-shadow:0 24px 80px rgba(0,0,0,0.5)">
            <div class="modal-body p-5 text-center">
                <div class="mb-4" style="width:80px;height:80px;background:linear-gradient(135deg, rgba(56,189,248,0.2), rgba(56,189,248,0.05));border-radius:24px;display:flex;align-items:center;justify-content:center;margin:0 auto;border:1px solid rgba(56,189,248,0.2)">
                    <i class="fas fa-satellite-dish fa-2x" style="color:var(--sky-blue);animation:pulse-blue 2s infinite"></i>
                </div>
                <h3 style="font-weight:900;color:##fff;margin-bottom:12px;letter-spacing:-1px">Mission Debrief</h3>
                <p style="color:var(--text-muted);font-size:14px;margin-bottom:32px;line-height:1.6">Verify your tactical responses before final transmission. Data once sent cannot be retracted.</p>
                
                <div class="row g-3 mb-5">
                    <div class="col-4">
                        <div class="p-3" style="background:rgba(34,197,94,0.05);border-radius:20px;border:1px solid rgba(34,197,94,0.15)">
                            <div id="reviewAnswered" style="font-size:24px;font-weight:900;color:##22c55e">0</div>
                            <div style="font-size:9px;color:rgba(34,197,94,0.8);text-transform:uppercase;font-weight:800;letter-spacing:1px;margin-top:4px">Active</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3" style="background:rgba(239,68,68,0.05);border-radius:20px;border:1px solid rgba(239,68,68,0.15)">
                            <div id="reviewUnanswered" style="font-size:24px;font-weight:900;color:##ef4444">0</div>
                            <div style="font-size:9px;color:rgba(239,68,68,0.8);text-transform:uppercase;font-weight:800;letter-spacing:1px;margin-top:4px">Void</div>
                        </div>
                    </div>
                    <div class="col-4">
                        <div class="p-3" style="background:rgba(251,191,36,0.05);border-radius:20px;border:1px solid rgba(251,191,36,0.15)">
                            <div id="reviewBookmarked" style="font-size:24px;font-weight:900;color:##fbbf24">0</div>
                            <div style="font-size:9px;color:rgba(251,191,36,0.8);text-transform:uppercase;font-weight:800;letter-spacing:1px;margin-top:4px">Signal</div>
                        </div>
                    </div>
                </div>

                <div class="d-grid gap-3">
                    <button class="dk-btn sky" style="padding:16px;font-weight:900;background:##22c55e;border-color:##22c55e;text-transform:uppercase;letter-spacing:1px;box-shadow:0 10px 20px rgba(34,197,94,0.2)" onclick="submitTest()">
                        <i class="fas fa-paper-plane me-2"></i> Transmit Results
                    </button>
                    <button class="dk-btn ghost" data-bs-dismiss="modal" style="padding:16px;font-weight:800;text-transform:uppercase;letter-spacing:1px">
                        Return to Mission
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
@keyframes pulse-blue {
    0% { transform: scale(1); opacity: 1; }
    50% { transform: scale(1.1); opacity: 0.7; }
    100% { transform: scale(1); opacity: 1; }
}
.dk-option.selected {
    background: rgba(56, 189, 248, 0.1) !important;
    border-color: var(--sky-blue) !important;
    box-shadow: 0 0 20px rgba(56, 189, 248, 0.15);
}
.dk-option.selected .opt-letter {
    background: var(--sky-blue) !important;
    color: ##000 !important;
}
.dk-option:hover {
    border-color: rgba(56, 189, 248, 0.3) !important;
    transform: translateX(5px);
}
.palette-item.answered {
    background: var(--sky-blue) !important;
    border-color: var(--sky-blue) !important;
    color: ##000 !important;
    box-shadow: 0 0 10px rgba(56, 189, 248, 0.3);
}
.palette-item.bookmarked {
    background: ##fbbf24 !important;
    border-color: ##fbbf24 !important;
    color: ##000 !important;
    box-shadow: 0 0 10px rgba(251, 191, 36, 0.3);
}
.palette-item.active {
    border-color: var(--sky-blue) !important;
    border-width: 2px !important;
    transform: scale(1.15);
    z-index: 2;
}
.custom-scrollbar::-webkit-scrollbar { width: 6px; }
.custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
.custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(56, 189, 248, 0.2); border-radius: 10px; }
</style>

<script>
document.addEventListener('DOMContentLoaded', function() {
    initTestEngine({
        attemptId: #prc.attempt.id#,
        totalQuestions: #prc.questions.recordCount#,
        durationMinutes: #prc.attemptDuration#
    });
});
</script>
</cfoutput>

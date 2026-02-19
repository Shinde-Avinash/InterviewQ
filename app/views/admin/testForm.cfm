<cfoutput>
<div class="page-header" style="animation:fadeSlideUp 0.3s ease both">
    <a href="#event.buildLink('admin/tests')#" class="dk-btn ghost mb-3" style="font-size:11px;padding:6px 12px">
        <i class="fas fa-arrow-left me-1"></i> Back to Roster
    </a>
    <h1 class="page-title"><cfif prc.isEdit>Modify Mission Parameters<cfelse>Draft New Mission</cfif></h1>
    <p class="page-desc">
        <cfif prc.isEdit>Updating tactical specifications for [#prc.test.title#]<cfelse>Define the parameters for a new simulation or mission</cfif>
    </p>
</div>

<div class="row" style="animation:fadeSlideUp-small 0.4s ease both;animation-delay:0.1s">
    <div class="col-lg-8">
        <div class="dk-card elite" style="padding:32px">
            <form action="#event.buildLink('admin/saveTest')#" method="POST">
                <input type="hidden" name="testId" value="#prc.test.id ?: 0#">
                
                <div class="row g-4">
                    <div class="col-md-12">
                        <label class="form-label elite-label">Mission Title</label>
                        <input type="text" name="title" class="form-control" value="#prc.test.title#" required placeholder="e.g. Advanced Java Concurrency">
                    </div>
                    
                    <div class="col-md-12">
                        <label class="form-label elite-label">Briefing / Description</label>
                        <textarea name="description" class="form-control" rows="3" required placeholder="Describe the objectives of this mission...">#prc.test.description#</textarea>
                    </div>
                    
                    <div class="col-md-6">
                        <label class="form-label elite-label">Intelligence Domain (Category)</label>
                        <select name="categoryId" class="form-select" required>
                            <option value="">Select Domain</option>
                            <cfloop query="prc.categories">
                                <option value="#id#" <cfif id EQ prc.test.category_id>selected</cfif>>#name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label elite-label">Complexity Level</label>
                        <select name="difficultyId" class="form-select" required>
                            <option value="">Select Level</option>
                            <cfloop query="prc.difficulties">
                                <option value="#id#" <cfif id EQ prc.test.difficulty_id>selected</cfif>>#name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label elite-label">Intel Count (Questions)</label>
                        <input type="number" name="totalQuestions" class="form-control" value="#prc.test.total_questions ?: 10#" required min="1" max="100">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label elite-label">Operation Time (Minutes)</label>
                        <input type="number" name="timeMinutes" class="form-control" value="#prc.test.time_minutes ?: 30#" required min="1">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label elite-label">Mission Type</label>
                        <div class="d-flex gap-3 pt-2">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="isPractice" id="typeTest" value="0" <cfif NOT prc.test.is_practice>checked</cfif>>
                                <label class="form-check-label" for="typeTest" style="color:rgba(148,163,184,0.8);font-size:13px">Mission</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="isPractice" id="typePractice" value="1" <cfif prc.test.is_practice>checked</cfif>>
                                <label class="form-check-label" for="typePractice" style="color:rgba(148,163,184,0.8);font-size:13px">Practice</label>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-6">
                        <div class="dk-inner-card p-3">
                            <div class="form-check form-switch mb-2">
                                <input class="form-check-input" type="checkbox" name="negativeMarking" id="negSwitch" <cfif prc.test.negative_marking>checked</cfif> value="1">
                                <label class="form-check-label elite-label mb-0" for="negSwitch">Negative Evaluation</label>
                            </div>
                            <p style="font-size:11px;color:rgba(148,163,184,0.5)">Penalty applied for incorrect intelligence data</p>
                            
                            <div id="negValWrap" class="mt-2" style="<cfif NOT prc.test.negative_marking>display:none</cfif>">
                                <label class="form-label elite-label" style="font-size:10px">Penalty Value (Percentage of mark)</label>
                                <input type="number" name="negativeMarkValue" class="form-control form-control-sm" value="#prc.test.negative_mark_value ?: 0.25#" step="0.25" min="0" max="1">
                            </div>
                        </div>
                    </div>

                    <cfif prc.isEdit>
                    <div class="col-md-6">
                        <div class="dk-inner-card p-3">
                            <div class="form-check form-switch">
                                <input class="form-check-input" type="checkbox" name="isActive" id="activeSwitch" <cfif prc.test.is_active>checked</cfif> value="1">
                                <label class="form-check-label elite-label mb-0" for="activeSwitch">Operational Status</label>
                            </div>
                            <p style="font-size:11px;color:rgba(148,163,184,0.5);margin-top:8px">Is this mission available for engagement?</p>
                        </div>
                    </div>
                    </cfif>
                </div>

                <div class="mt-5 d-flex gap-3">
                    <button type="submit" class="dk-btn sky px-5" style="font-weight:900">
                        <i class="fas fa-satellite-dish me-2"></i> <cfif prc.isEdit>Commit Update<cfelse>Deploy Mission</cfif>
                    </button>
                    <a href="#event.buildLink('admin/tests')#" class="dk-btn ghost">Abort</a>
                </div>
            </form>
        </div>
    </div>
    
    <div class="col-lg-4">
        <div class="dk-card" style="background:rgba(56,189,248,0.02);border-style:dashed;padding:28px">
            <h6 style="color:##fff;font-weight:800;margin-bottom:16px;display:flex;align-items:center;gap:10px">
                <i class="fas fa-info-circle" style="color:var(--sky-blue)"></i> Tactical Intel
            </h6>
            <div style="font-size:13px;color:rgba(148,163,184,0.7);line-height:1.7">
                <p>When you deploy a mission, the system will dynamically pull the specified number of questions from the chosen domain and complexity level.</p>
                <div class="mt-3 p-2 rounded" style="background:rgba(0,0,0,0.2);border:1px solid rgba(148,163,184,0.1)">
                    <i class="fas fa-lightbulb me-2" style="color:##fbbf24"></i>
                    <strong>Pro-Tip:</strong> Ensure your question bank has enough entries for the selected Domain and Complexity combination.
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.getElementById('negSwitch').addEventListener('change', function(){
    document.getElementById('negValWrap').style.display = this.checked ? 'block' : 'none';
});
</script>

<style>
.elite-label {
    font-size: 11px;
    font-weight: 700;
    color: ##94a3b8;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 8px;
    display: block;
}
.dk-inner-card {
    background: rgba(0,0,0,0.15);
    border: 1px solid rgba(148,163,184,0.08);
    border-radius: 10px;
}
@keyframes fadeSlideUp-small {
    from { opacity: 0; transform: translateY(6px); }
    to { opacity: 1; transform: translateY(0); }
}
</style>
</cfoutput>

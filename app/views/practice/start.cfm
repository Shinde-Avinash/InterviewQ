<cfoutput>
<div class="container container-dark pb-5">
    <div class="d-flex justify-content-between align-items-center mb-5" style="animation:fadeSlideUp 0.4s ease both">
        <div>
            <h1 class="page-title">Practice Session</h1>
            <p class="page-desc" style="color:var(--sky-blue);font-weight:600">
                <i class="fas fa-layer-group me-2"></i> #prc.questions.recordCount# Questions
                <span class="mx-3" style="opacity:0.3">|</span>
                <i class="fas fa- бесконечность me-1"></i> No Time Limit
            </p>
        </div>
        <a href="#event.buildLink('practice')#" class="dk-btn ghost" style="padding:10px 24px">
            <i class="fas fa-arrow-left me-2"></i> Exit Session
        </a>
    </div>

    <div style="max-width:900px;margin:0 auto">
        <cfset qNum = 1>
        <cfloop query="prc.questions">
            <div class="dk-card mb-5" id="practice-q-#id#" style="animation:fadeSlideUp 0.5s ease both;animation-delay:#(qNum * 0.1)#s">
                <div style="font-weight:700;font-size:18px;color:##fff;margin-bottom:24px;line-height:1.6">
                    <span style="color:var(--sky-blue);margin-right:10px">Q#qNum#.</span> #question_text#
                </div>

                <cfif len(code_snippet)>
                    <pre class="mb-4" style="background:rgba(15,23,42,0.8);border:1px solid rgba(148,163,184,0.1);border-radius:12px;padding:20px;font-size:14px"><code class="language-javascript">#code_snippet#</code></pre>
                </cfif>

                <div id="opts-#id#" class="d-grid gap-3">
                    <cfset opts = prc.allOptions[id]>
                    <cfset optLetters = ["A","B","C","D","E","F"]>
                    <cfset oi = 1>
                    <cfloop query="opts">
                        <div class="dk-option" onclick="checkPracticeAnswer(#prc.questions.id#, #opts.id#, this)">
                            <div class="opt-letter">#optLetters[oi]#</div>
                            <div class="opt-text">#opts.option_text#</div>
                        </div>
                        <cfset oi++>
                    </cfloop>
                </div>

                <div id="feedback-#id#" class="mt-4" style="display:none;animation:fadeSlideUp 0.3s ease both"></div>
            </div>
            <cfset qNum++>
        </cfloop>

        <cfif NOT prc.questions.recordCount>
            <div class="dk-card text-center py-5">
                <i class="fas fa-search fa-3x mb-3 opacity-20" style="color:var(--sky-blue)"></i>
                <p style="color:var(--text-muted);font-size:15px">No questions matched your current activity settings.</p>
                <a href="#event.buildLink('practice')#" class="dk-btn sky mt-3">Adjust Filters</a>
            </div>
        </cfif>
    </div>
</div>

<script>
async function checkPracticeAnswer(questionId, optionId, element) {
    const group = document.getElementById('opts-' + questionId);
    const feedbackDiv = document.getElementById('feedback-' + questionId);

    if(element.classList.contains('correct') || element.classList.contains('incorrect')) return;

    group.querySelectorAll('.dk-option').forEach(opt => {
        opt.style.pointerEvents = 'none';
        opt.style.opacity = '0.7';
    });
    element.style.opacity = '1';
    element.classList.add('selected');

    try {
        const result = await apiCall('/api/checkAnswer', {
            questionId: questionId,
            selectedOptionId: optionId
        });

        element.classList.remove('selected');
        if (result.isCorrect) {
            element.classList.add('correct');
        } else {
            element.classList.add('incorrect');
            // Highlight correct one
            group.querySelectorAll('.dk-option').forEach(opt => {
                // We don't have the correct option ID in the loop easily without extra data
                // but the API could return it. For now focus on the user's choice.
            });
        }

        feedbackDiv.style.display = 'block';
        feedbackDiv.innerHTML = `
            <div style="padding:16px;background:${result.isCorrect ? 'rgba(34,197,94,0.08)' : 'rgba(239,68,68,0.08)'};
                border-left:4px solid ${result.isCorrect ? '##22c55e' : '##ef4444'};border-radius:4px 12px 12px 4px">
                <div style="font-weight:800;font-size:14px;color:${result.isCorrect ? '##22c55e' : '##ef4444'};margin-bottom:8px;display:flex;align-items:center;gap:8px">
                    <i class="fas ${result.isCorrect ? 'fa-check-circle' : 'fa-times-circle'}"></i>
                    ${result.isCorrect ? 'Correct Answer!' : 'Incorrect Answer'}
                </div>
                <div style="font-size:13px;color:rgba(255,255,255,0.7);line-height:1.6">
                    ${result.explanation ? result.explanation : 'The correct answer was: <strong>' + result.correctText + '</strong>'}
                </div>
            </div>
        `;
    } catch(err) {
        console.error(err);
        group.querySelectorAll('.dk-option').forEach(opt => opt.style.pointerEvents = 'auto');
    }
}
</script>
</cfoutput>

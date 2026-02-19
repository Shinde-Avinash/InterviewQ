/**
 * Test Engine — Timer, question navigation, bookmarks, auto-submit
 */

let currentQuestion = 0;
let totalQuestions = 0;
let timerInterval = null;
let remainingSeconds = 0;
let attemptId = 0;

function initTestEngine(config) {
    attemptId = config.attemptId;
    totalQuestions = config.totalQuestions;
    remainingSeconds = config.durationMinutes * 60;

    showQuestion(0);
    startTimer();
    updatePalette();
}

// ==================== Timer ====================
function startTimer() {
    const timerEl = document.getElementById('timer');
    updateTimerDisplay();

    timerInterval = setInterval(function() {
        remainingSeconds--;
        updateTimerDisplay();

        if (remainingSeconds <= 60) {
            timerEl.classList.add('danger');
        } else if (remainingSeconds <= 300) {
            timerEl.classList.add('warning');
            timerEl.classList.remove('danger');
        }

        if (remainingSeconds <= 0) {
            clearInterval(timerInterval);
            autoSubmitTest();
        }
    }, 1000);
}

function updateTimerDisplay() {
    const timerEl = document.getElementById('timer');
    const mins = Math.floor(remainingSeconds / 60);
    const secs = remainingSeconds % 60;
    timerEl.textContent = `${String(mins).padStart(2,'0')}:${String(secs).padStart(2,'0')}`;
}

// ==================== Question Navigation ====================
function showQuestion(index) {
    document.querySelectorAll('.question-slide').forEach(el => el.style.display = 'none');
    const q = document.getElementById('question-' + index);
    if (q) q.style.display = 'block';
    currentQuestion = index;

    document.getElementById('questionCounter').textContent = `Question ${index + 1} of ${totalQuestions}`;

    // Update palette
    document.querySelectorAll('.palette-item').forEach(btn => btn.classList.remove('active'));
    const activeBtn = document.querySelector(`.palette-item[data-index="${index}"]`);
    if (activeBtn) activeBtn.classList.add('active');

    // Navigation buttons
    document.getElementById('prevBtn').disabled = index === 0;
    document.getElementById('nextBtn').style.display = index === totalQuestions - 1 ? 'none' : 'inline-flex';
    document.getElementById('submitBtn').style.display = index === totalQuestions - 1 ? 'inline-flex' : 'none';
}

function nextQuestion() {
    if (currentQuestion < totalQuestions - 1) showQuestion(currentQuestion + 1);
}

function prevQuestion() {
    if (currentQuestion > 0) showQuestion(currentQuestion - 1);
}

// ==================== Answer Selection ====================
function selectOption(questionId, optionId, element) {
    // Visual update
    const parent = element.closest('.options-group');
    parent.querySelectorAll('.dk-option').forEach(opt => opt.classList.remove('selected'));
    element.classList.add('selected');

    // Save to server via AJAX
    apiCall('/api/saveAnswer', {
        attemptId: attemptId,
        questionId: questionId,
        selectedOptionId: optionId
    }).then(result => {
        updatePalette();
    });
}

// ==================== Bookmark ====================
function toggleBookmark(questionId, btn) {
    apiCall('/api/toggleBookmark', {
        attemptId: attemptId,
        questionId: questionId
    }).then(result => {
        btn.classList.toggle('text-warning');
        updatePalette();
    });
}

// ==================== Palette Update ====================
function updatePalette() {
    document.querySelectorAll('.question-slide').forEach((slide, index) => {
        const paletteBtn = document.querySelector(`.palette-item[data-index="${index}"]`);
        if (!paletteBtn) return;

        const hasAnswer = slide.querySelector('.dk-option.selected');
        const bookmarkBtn = slide.querySelector('.bookmark-btn');
        const isBookmarked = bookmarkBtn && bookmarkBtn.classList.contains('text-warning');

        paletteBtn.classList.remove('answered', 'bookmarked');
        if (hasAnswer) paletteBtn.classList.add('answered');
        if (isBookmarked) paletteBtn.classList.add('bookmarked');
    });
}

// ==================== Submit ====================
function submitTest() {
    // Count unanswered
    let unanswered = 0;
    document.querySelectorAll('.question-slide').forEach(slide => {
        if (!slide.querySelector('.dk-option.selected')) unanswered++;
    });

    let title = 'Final Submission';
    let text = 'Are you sure you want to submit your mission results?';
    let icon = 'question';

    if (unanswered > 0) {
        title = 'Submit Test?';
        text = `You have ${unanswered} unanswered question(s). Are you sure you want to submit?`;
        icon = 'warning';
    }

    Swal.fire({
        title: title,
        text: text,
        icon: icon,
        showCancelButton: true,
        confirmButtonColor: '#22c55e',
        cancelButtonColor: 'rgba(148,163,184,0.1)',
        confirmButtonText: 'Transmit Results',
        cancelButtonText: 'Return to Mission',
        background: 'rgba(10,14,30,0.95)',
        color: '#fff',
        backdrop: `rgba(0,0,0,0.4) blur(4px)`
    }).then((result) => {
        if (result.isConfirmed) {
            doSubmit();
        }
    });
}

function autoSubmitTest() {
    showToast("Time's up! Your test is being submitted automatically.", 'warning');
    setTimeout(doSubmit, 1500);
}

function doSubmit() {
    showLoading();
    apiCall('/api/submitTest', { attemptId: attemptId }).then(result => {
        if (result.success) {
            window.location.href = '/test/result?attemptId=' + attemptId;
        } else {
            hideLoading();
            showToast('Failed to submit test. Please try again.', 'error');
        }
    });
}

// ==================== Review Before Submit ====================
function showReviewModal() {
    let answered = 0, bookmarked = 0, unanswered = 0;
    document.querySelectorAll('.question-slide').forEach(slide => {
        if (slide.querySelector('.dk-option.selected')) {
            answered++;
        } else {
            unanswered++;
        }
    });
    document.querySelectorAll('.bookmark-btn.text-warning').forEach(() => bookmarked++);

    document.getElementById('reviewAnswered').textContent = answered;
    document.getElementById('reviewUnanswered').textContent = unanswered;
    document.getElementById('reviewBookmarked').textContent = bookmarked;

    const modal = new bootstrap.Modal(document.getElementById('reviewModal'));
    modal.show();
}

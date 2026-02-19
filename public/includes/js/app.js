/**
 * InterviewPrep — Main Application JavaScript
 * Theme toggle, toast notifications, loading spinner, utilities
 */

// ==================== Theme Toggle ====================
(function() {
    const savedTheme = localStorage.getItem('ip-theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
})();

function toggleTheme() {
    const html = document.documentElement;
    const current = html.getAttribute('data-theme');
    const next = current === 'dark' ? 'light' : 'dark';
    html.setAttribute('data-theme', next);
    localStorage.setItem('ip-theme', next);

    const icon = document.getElementById('themeIcon');
    if (icon) {
        icon.className = next === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    }
}

// ==================== Toast Notifications ====================
function showToast(message, type = 'success', duration = 4000) {
    const container = document.getElementById('toastContainer');
    if (!container) return;

    const icons = {
        success: 'fa-check-circle',
        error:   'fa-exclamation-circle',
        warning: 'fa-exclamation-triangle',
        info:    'fa-info-circle'
    };
    const colors = {
        success: '#22c55e',
        error:   '#ef4444',
        warning: '#f59e0b',
        info:    '#0ea5e9'
    };

    const toast = document.createElement('div');
    toast.className = 'toast-premium';
    toast.innerHTML = `
        <i class="fas ${icons[type] || icons.info}" style="color:${colors[type] || colors.info};font-size:1.2rem"></i>
        <span style="flex:1;font-weight:500">${message}</span>
        <button onclick="this.parentElement.remove()" style="border:none;background:none;cursor:pointer;color:var(--text-muted)">
            <i class="fas fa-times"></i>
        </button>
    `;
    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'slideIn 0.3s ease reverse';
        setTimeout(() => toast.remove(), 300);
    }, duration);
}

// ==================== Loading Spinner ====================
function showLoading() {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) overlay.classList.add('active');
}

function hideLoading() {
    const overlay = document.getElementById('loadingOverlay');
    if (overlay) overlay.classList.remove('active');
}

// ==================== AJAX Helper ====================
async function apiCall(url, data = {}) {
    showLoading();
    try {
        const params = new URLSearchParams(data);
        const response = await fetch(url, {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: params
        });
        const result = await response.json();
        hideLoading();
        return result;
    } catch (error) {
        hideLoading();
        showToast('An error occurred. Please try again.', 'error');
        console.error('API Error:', error);
        return { success: false };
    }
}

// ==================== Animations ====================
document.addEventListener('DOMContentLoaded', function() {
    // Fade-in elements on scroll
    const observerOptions = { threshold: 0.1, rootMargin: '0px 0px -50px 0px' };
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    document.querySelectorAll('.animate-on-scroll').forEach(el => observer.observe(el));

    // Update theme icon
    const theme = document.documentElement.getAttribute('data-theme');
    const icon = document.getElementById('themeIcon');
    if (icon) {
        icon.className = theme === 'dark' ? 'fas fa-sun' : 'fas fa-moon';
    }
});

// ==================== Confirm Delete ====================
function confirmDelete(message, url) {
    if (confirm(message || 'Are you sure you want to delete this?')) {
        window.location.href = url;
    }
}

// ==================== Sidebar Toggle (Admin Mobile) ====================
function toggleSidebar() {
    const sidebar = document.querySelector('.sidebar');
    if (sidebar) sidebar.classList.toggle('show');
}

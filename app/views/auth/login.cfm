<cfoutput>
<div class="auth-box" style="width: 100%; max-width: 400px;">
    <div class="text-center mb-4">
        <i class="fas fa-graduation-cap text-sky mb-2" style="font-size: 32px;"></i>
        <h2 class="fw-bold text-white mb-1">Sign in</h2>
        <p class="text-white-50" style="font-size: 13px;">Enter your credentials to access your account</p>
    </div>

    <form action="#event.buildLink('auth/doLogin')#" method="POST">
        <div class="field mb-3">
            <label for="username" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Username / Email</label>
            <input type="text" id="username" name="username" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="Enter your username" required autocomplete="username">
        </div>
        <div class="field mb-4">
            <label for="password" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Password</label>
            <input type="password" id="password" name="password" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="Enter your password" required autocomplete="current-password">
        </div>
        <button type="submit" class="dk-btn sky w-100 py-2 fw-bold text-uppercase" style="letter-spacing: 1px;">Authorize Session</button>
    </form>

    <div class="demo-section mt-4 pt-3 border-top border-secondary opacity-75">
        <div class="demo-title small text-uppercase fw-bold text-white-50 mb-3" style="font-size: 10px; letter-spacing: 1px;">Quick Access Units</div>
        <div class="d-flex flex-column gap-2">
            <button type="button" class="dk-btn ghost py-2 text-start" style="border-color: rgba(56,189,248,0.2);" onclick="document.getElementById('username').value='admin';document.getElementById('password').value='admin123'">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-user-shield text-sky"></i>
                    <div>
                        <div class="text-white small fw-bold">Admin</div>
                        <div class="text-white-50 smaller" style="font-size: 11px;">admin / admin123</div>
                    </div>
                </div>
            </button>
            <button type="button" class="dk-btn ghost py-2 text-start" style="border-color: rgba(148,163,184,0.2);" onclick="document.getElementById('username').value='student';document.getElementById('password').value='student123'">
                <div class="d-flex align-items-center gap-2">
                    <i class="fas fa-user-graduate text-sky"></i>
                    <div>
                        <div class="text-white small fw-bold">Student</div>
                        <div class="text-white-50 smaller" style="font-size: 11px;">student / student123</div>
                    </div>
                </div>
            </button>
        </div>
    </div>
    
    <div class="text-center mt-4">
        <p class="text-white-50 small">New to the initiative? <a href="#event.buildLink('auth/register')#" class="text-sky fw-bold text-decoration-none">Create Account</a></p>
    </div>
</div>
</cfoutput>

<cfoutput>
<div class="auth-container">
    <div class="auth-card" style="max-width:500px">
        <div class="auth-form-side">
            <div style="text-align:center;margin-bottom:2rem">
                <div class="mobile-logo" style="display:block">
                    <div class="logo-icon"><i class="fas fa-brain"></i></div>
                    <h4>InterviewPrep</h4>
                </div>
            </div>

            <div class="form-header" style="text-align:center">
                <h3>Reset Password 🔑</h3>
                <p>Enter your email and we'll send you reset instructions</p>
            </div>

            <form action="#event.buildLink('auth/doForgotPassword')#" method="POST">
                <div class="input-group-premium">
                    <i class="fas fa-envelope input-icon"></i>
                    <input type="email" name="email" placeholder="Your email address" required autocomplete="email">
                </div>

                <button type="submit" class="btn-submit">
                    Send Reset Link <i class="fas fa-paper-plane ms-2"></i>
                </button>
            </form>

            <p class="footer-text">
                Remember your password? <a href="#event.buildLink('auth/login')#">Sign in</a>
            </p>
        </div>
    </div>
</div>
</cfoutput>

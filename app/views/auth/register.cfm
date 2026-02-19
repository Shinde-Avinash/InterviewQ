<cfoutput>
<div class="auth-box" style="width: 100%; max-width: 500px;">
    <div class="text-center mb-4">
        <i class="fas fa-graduation-cap text-sky mb-2" style="font-size: 32px;"></i>
        <h2 class="fw-bold text-white mb-1">Create an account</h2>
        <p class="text-white-50" style="font-size: 13px;">Get started with your interview preparation</p>
    </div>

    <form action="#event.buildLink('auth/doRegister')#" method="POST">
        <div class="row g-3 mb-3">
            <div class="col-md-6">
                <label for="firstName" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">First name</label>
                <input type="text" id="firstName" name="firstName" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="John" required>
            </div>
            <div class="col-md-6">
                <label for="lastName" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Last name</label>
                <input type="text" id="lastName" name="lastName" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="Doe" required>
            </div>
        </div>
        <div class="field mb-3">
            <label for="username" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Username</label>
            <input type="text" id="username" name="username" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="johndoe" required autocomplete="username">
        </div>
        <div class="field mb-3">
            <label for="email" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Email Address</label>
            <input type="email" id="email" name="email" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="john@example.com" required autocomplete="email">
        </div>
        <div class="field mb-3">
            <label for="password" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Password</label>
            <input type="password" id="password" name="password" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="Min 6 characters" required minlength="6" autocomplete="new-password">
        </div>
        <div class="field mb-4">
            <label for="confirmPassword" class="form-label text-white fw-bold small text-uppercase" style="letter-spacing: 1px;">Confirm Password</label>
            <input type="password" id="confirmPassword" name="confirmPassword" class="form-control bg-transparent text-white border-secondary py-2" style="background: rgba(255,255,255,0.05) !important;" placeholder="Re-enter password" required minlength="6" autocomplete="new-password">
        </div>
        
        <button type="submit" class="dk-btn sky w-100 py-2 fw-bold text-uppercase" style="letter-spacing: 1px;">Initialize Account</button>
    </form>

    <div class="text-center mt-4">
        <p class="text-white-50 small">Already have an account? <a href="#event.buildLink('auth/login')#" class="text-sky fw-bold text-decoration-none">Sign In</a></p>
    </div>
</div>
</cfoutput>

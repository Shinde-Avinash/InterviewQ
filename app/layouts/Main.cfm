<cfoutput>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="InterviewPrep — Practice MCQ tests for interview preparation">
    <base href="#event.getHTMLBaseURL()#" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <link href="includes/css/app.css" rel="stylesheet">
    <link href="includes/css/global-dark.css" rel="stylesheet">
    <title>InterviewPrep</title>
</head>
<body class="dark-mode-body d-flex flex-column min-vh-100">
    <!--- Star Canvas --->
    <canvas id="starCanvas"></canvas>
    <div id="toastContainer" class="toast-container"></div>

    <div class="elite-app-wrapper" id="appWrapper">
        <!--- Sidebar --->
        <aside class="elite-sidebar" id="mainSidebar">
            <button class="sidebar-toggle" id="toggleSidebar">
                <i class="fas fa-chevron-left"></i>
            </button>
            <div class="sidebar-header">
                <div class="brand-icon"><i class="fas fa-graduation-cap"></i></div>
                <span class="sidebar-brand-text">InterviewPrep</span>
            </div>
            
            <nav class="sidebar-nav">
                <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn>
                    <a href="#event.buildLink('dashboard')#" class="sidebar-link <cfif event.getCurrentHandler() EQ 'Dashboard'>active</cfif>">
                        <i class="fas fa-tachometer-alt"></i><span>Dashboard</span>
                    </a>
                    <a href="#event.buildLink('test')#" class="sidebar-link <cfif event.getCurrentHandler() EQ 'Test'>active</cfif>">
                        <i class="fas fa-clipboard-check"></i><span>Available Tests</span>
                    </a>
                    <a href="#event.buildLink('practice')#" class="sidebar-link <cfif event.getCurrentHandler() EQ 'Practice'>active</cfif>">
                        <i class="fas fa-microscope"></i><span>Practice Mode</span>
                    </a>
                    <a href="#event.buildLink('leaderboard')#" class="sidebar-link <cfif event.getCurrentHandler() EQ 'Leaderboard'>active</cfif>">
                        <i class="fas fa-trophy"></i><span>Leaderboard</span>
                    </a>
                    
                    <cfif session.roleName EQ "Admin">
                        <div class="sidebar-label">Command Center</div>
                        <a href="#event.buildLink('admin')#" class="sidebar-link">
                            <i class="fas fa-shield-halved"></i><span>Admin Panel</span>
                        </a>
                    </cfif>
                <cfelse>
                    <cfset homeLink = event.buildLink('')>
                    <a href="#homeLink#" class="sidebar-link <cfif event.getCurrentHandler() EQ 'Main' AND event.getCurrentAction() EQ 'index'>active</cfif>">
                        <i class="fas fa-house"></i><span>Home</span>
                    </a>
                    <a href="#homeLink###features" class="sidebar-link">
                        <i class="fas fa-star"></i><span>Features</span>
                    </a>
                    <a href="#homeLink###testimonials" class="sidebar-link">
                        <i class="fas fa-comment-dots"></i><span>Success Stories</span>
                    </a>
                    <div class="sidebar-label">Authentication</div>
                    <a href="#event.buildLink('auth/login')#" class="sidebar-link <cfif event.getCurrentAction() CONTAINS 'login'>active</cfif>">
                        <i class="fas fa-sign-in-alt"></i><span>Sign In</span>
                    </a>
                    <a href="#event.buildLink('auth/register')#" class="sidebar-link <cfif event.getCurrentAction() CONTAINS 'register'>active</cfif>">
                        <i class="fas fa-user-plus"></i><span>Get Started</span>
                    </a>
                </cfif>
            </nav>

            <cfif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn>
                <div class="sidebar-footer">
                    <div class="dropdown w-100 profile-dropdown">
                        <a href="##" class="dropdown-toggle d-flex align-items-center gap-2 text-decoration-none" data-bs-toggle="dropdown">
                            <div class="avatar-sm flex-shrink-0" style="background:var(--sky-blue);color:##0a0e1a;width:32px;height:32px;font-size:12px;font-weight:800;border:2px solid rgba(255,255,255,0.1)">#uCase(left(session.username, 1))#</div>
                            <span class="profile-name fw-semibold">#session.username#</span>
                        </a>
                        <ul class="dropdown-menu dropdown-menu-end shadow border" style="border-radius:8px;font-size:13px;background:rgba(15,23,42,0.9);backdrop-filter:blur(10px)">
                            <li><a class="dropdown-item py-2" href="#event.buildLink('dashboard')#"><i class="fas fa-user me-2" style="width:14px"></i>Profile</a></li>
                            <li><hr class="dropdown-divider"></li>
                            <li><a class="dropdown-item py-2 text-danger" href="#event.buildLink('auth/logout')#"><i class="fas fa-sign-out-alt me-2" style="width:14px"></i>Logout</a></li>
                        </ul>
                    </div>
                </div>
            </cfif>
        </aside>
        
        <!--- Mobile toggle --->
        <button class="btn btn-sm d-lg-none position-fixed" 
                style="top:12px;left:12px;z-index:1001;background:var(--sky-blue);border-radius:8px;padding:8px 12px"
                onclick="document.getElementById('mainSidebar').classList.toggle('show-mobile')">
            <i class="fas fa-bars"></i>
        </button>

        <div class="main-content-wrapper">
            <!--- Flash Messages --->
            <cfif flash.exists("success")>
                <script>document.addEventListener('DOMContentLoaded', () => showToast('#flash.get("success")#', 'success'));</script>
            </cfif>
            <cfif flash.exists("error")>
                <script>document.addEventListener('DOMContentLoaded', () => showToast('#flash.get("error")#', 'error'));</script>
            </cfif>

            <cfset mainClass = "flex-grow-1 d-flex flex-column">
            <cfif structKeyExists(prc, "isAuthPage") AND prc.isAuthPage>
                <cfset mainClass = mainClass & " p-4 align-items-center justify-content-center">
            <cfelseif structKeyExists(session, "isLoggedIn") AND session.isLoggedIn>
                <cfset mainClass = mainClass & " p-4">
            </cfif>

            <main class="#mainClass#">
                #view()#
            </main>

            <footer class="footer-dark py-4 mt-auto" style="background:rgba(10,14,30,0.2);border-top:1px solid rgba(148,163,184,0.05)">
                <div class="container-fluid px-4">
                    <div class="d-flex justify-content-between align-items-center" style="font-size:12px;color:rgba(148,163,184,0.4)">
                        <div>&copy; #year(now())# InterviewPrep &middot; Modern Learning Intel</div>
                        <div class="d-flex gap-3">
                            <a href="##" class="text-decoration-none color-inherit">Privacy</a>
                            <a href="##" class="text-decoration-none color-inherit">Terms</a>
                        </div>
                    </div>
                </div>
            </footer>
        </div>
    </div>

    <!--- Sidebar JS Logic --->
    <script>
    document.addEventListener('DOMContentLoaded', () => {
        const toggleBtn = document.getElementById('toggleSidebar');
        const sidebar = document.getElementById('mainSidebar');
        const wrapper = document.getElementById('appWrapper');
        
        if (toggleBtn && sidebar && wrapper) {
            // Load state
            const isCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
            if (isCollapsed) {
                sidebar.classList.add('is-collapsed');
                wrapper.classList.add('sidebar-collapsed-layout');
            }

            toggleBtn.addEventListener('click', () => {
                sidebar.classList.toggle('is-collapsed');
                wrapper.classList.toggle('sidebar-collapsed-layout');
                localStorage.setItem('sidebarCollapsed', sidebar.classList.contains('is-collapsed'));
            });
        }
    });
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="includes/js/app.js"></script>

    <!--- Star Animation --->
    <script>
    (function(){
        const c = document.getElementById('starCanvas');
        if(!c) return;
        const ctx = c.getContext('2d');
        let stars = [];
        const COUNT = 150;
        function resize(){ c.width = window.innerWidth; c.height = window.innerHeight; }
        function init(){
            resize(); stars = [];
            for(let i = 0; i < COUNT; i++){
                stars.push({
                    x: Math.random() * c.width, y: Math.random() * c.height,
                    r: Math.random() * 1.4 + 0.3, a: Math.random(),
                    da: (Math.random() - 0.5) * 0.01, dy: Math.random() * 0.15 + 0.02
                });
            }
        }
        function draw(){
            ctx.clearRect(0, 0, c.width, c.height);
            stars.forEach(s => {
                s.a += s.da; if(s.a <= 0 || s.a >= 1) s.da *= -1;
                s.y += s.dy; if(s.y > c.height) { s.y = 0; s.x = Math.random() * c.width; }
                ctx.beginPath(); ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(148,163,184,' + Math.abs(s.a) + ')';
                ctx.fill();
            });
            requestAnimationFrame(draw);
        }
        window.addEventListener('resize', resize);
        init(); draw();
    })();
    </script>
</body>
</html>
</cfoutput>

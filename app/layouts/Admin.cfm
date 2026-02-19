<cfoutput>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <base href="#event.getHTMLBaseURL()#" />
    <link href="includes/css/app.css" rel="stylesheet">
    <link href="includes/css/global-dark.css" rel="stylesheet">
    <title>InterviewPrep — Admin</title>
</head>
<body class="dark-mode-body">
    <!--- Star Canvas --->
    <canvas id="starCanvas"></canvas>

    <div id="toastContainer" class="toast-container"></div>

    <cfif flash.exists("success")>
        <script>document.addEventListener('DOMContentLoaded', () => showToast('#flash.get("success")#', 'success'));</script>
    </cfif>
    <cfif flash.exists("error")>
        <script>document.addEventListener('DOMContentLoaded', () => showToast('#flash.get("error")#', 'error'));</script>
    </cfif>

    <div class="elite-app-wrapper" id="appWrapper">
        <!--- Sidebar --->
        <aside class="elite-sidebar" id="mainSidebar">
            <button class="sidebar-toggle" id="toggleSidebar">
                <i class="fas fa-chevron-left"></i>
            </button>
            <div class="sidebar-header">
                <div class="brand-icon"><i class="fas fa-graduation-cap"></i></div>
                <span class="sidebar-brand-text">InterviewPrep Admin</span>
            </div>
            <nav class="sidebar-nav">
                <a class="sidebar-link <cfif event.getCurrentHandler() EQ 'admin' AND event.getCurrentAction() EQ 'index'>active</cfif>" href="#event.buildLink('admin')#">
                    <i class="fas fa-tachometer-alt"></i><span>Dashboard</span>
                </a>
                <a class="sidebar-link <cfif event.getCurrentHandler() EQ 'admin' AND event.getCurrentAction() CONTAINS 'Question'>active</cfif>" href="#event.buildLink('admin/questions')#">
                    <i class="fas fa-question-circle"></i><span>Questions</span>
                </a>
                <a class="sidebar-link <cfif event.getCurrentHandler() EQ 'admin' AND event.getCurrentAction() CONTAINS 'Test'>active</cfif>" href="#event.buildLink('admin/tests')#">
                    <i class="fas fa-clipboard-check"></i><span>Tests</span>
                </a>
                <a class="sidebar-link <cfif event.getCurrentHandler() EQ 'admin' AND event.getCurrentAction() CONTAINS 'Categor'>active</cfif>" href="#event.buildLink('admin/categories')#">
                    <i class="fas fa-tags"></i><span>Categories</span>
                </a>
                <a class="sidebar-link <cfif event.getCurrentHandler() EQ 'admin' AND event.getCurrentAction() CONTAINS 'User'>active</cfif>" href="#event.buildLink('admin/users')#">
                    <i class="fas fa-users"></i><span>Users</span>
                </a>
                <div class="sidebar-label">Navigation</div>
                <a class="sidebar-link" href="#event.buildLink('dashboard')#">
                    <i class="fas fa-arrow-left"></i><span>Back to App</span>
                </a>
                <a class="sidebar-link" href="#event.buildLink('auth/logout')#">
                    <i class="fas fa-sign-out-alt"></i><span>Logout</span>
                </a>
            </nav>
        </aside>

        <!--- Mobile toggle --->
        <button class="btn btn-sm d-lg-none position-fixed"
                style="top:12px;left:12px;z-index:1001;background:var(--sky-blue);color:##0a0e1a;border-radius:8px;border:none;padding:8px 12px"
                onclick="document.getElementById('mainSidebar').classList.toggle('show-mobile')">
            <i class="fas fa-bars"></i>
        </button>

        <div class="main-content-wrapper admin-main-wrapper">
            <div class="p-4">
                #view()#
            </div>

            <footer class="mt-auto py-4 px-4 border-top" style="border-color:rgba(148,163,184,0.05);font-size:12px;color:var(--text-muted)">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <strong>InterviewPrep Command</strong> &middot; #year(now())#
                    </div>
                    <div class="d-flex gap-3">
                        <span style="opacity:0.5;letter-spacing:1px">SYSTEM STATUS: <span style="color:##22c55e">ACTIVE</span></span>
                        <span style="opacity:0.3">|</span>
                        <span style="opacity:0.5;letter-spacing:1px">V2.1-ELITE</span>
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

        function resize(){
            c.width = window.innerWidth;
            c.height = window.innerHeight;
        }

        function init(){
            resize();
            stars = [];
            for(let i = 0; i < COUNT; i++){
                stars.push({
                    x: Math.random() * c.width,
                    y: Math.random() * c.height,
                    r: Math.random() * 1.4 + 0.3,
                    a: Math.random(),
                    da: (Math.random() - 0.5) * 0.01,
                    dy: Math.random() * 0.15 + 0.02
                });
            }
        }

        function draw(){
            ctx.clearRect(0, 0, c.width, c.height);
            stars.forEach(s => {
                s.a += s.da;
                if(s.a <= 0 || s.a >= 1) s.da *= -1;
                s.y += s.dy;
                if(s.y > c.height) { s.y = 0; s.x = Math.random() * c.width; }
                ctx.beginPath();
                ctx.arc(s.x, s.y, s.r, 0, Math.PI * 2);
                ctx.fillStyle = 'rgba(148,163,184,' + Math.abs(s.a) + ')';
                ctx.fill();
            });
            requestAnimationFrame(draw);
        }

        window.addEventListener('resize', resize);
        init();
        draw();
    })();
    </script>
</body>
</html>
</cfoutput>

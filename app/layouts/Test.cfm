<cfoutput>
<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <base href="#event.getHTMLBaseURL()#" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/themes/prism-tomorrow.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link href="includes/css/app.css" rel="stylesheet">
    <link href="includes/css/global-dark.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
    <title>InterviewPrep — MISSION INITIATED</title>
</head>
<body class="dark-mode-body d-flex flex-column min-vh-100">
    <!--- Star Canvas --->
    <canvas id="starCanvas"></canvas>

    <div id="loadingOverlay" class="loading-overlay"><div class="spinner-s"></div></div>
    <div id="toastContainer" class="toast-container"></div>

    <div class="elite-app-wrapper" id="appWrapper">
        <div class="main-content-wrapper w-100 ms-0">
            <main class="flex-grow-1 p-3 p-md-4 d-flex flex-column" style="position:relative;z-index:1">
                #view()#
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/prism/1.29.0/prism.min.js"></script>
    <script src="includes/js/app.js"></script>
    <script src="includes/js/test-engine.js?v=#getTickCount()#"></script>

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

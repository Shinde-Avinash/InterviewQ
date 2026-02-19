<cfoutput>
<!--- Landing Page Hero --->
<section class="content-dark" style="padding:40px 0 30px">
    <div class="container">
        <div class="row align-items-center">
            <div class="col-lg-6 mb-3 mb-lg-0" style="animation:fadeSlideUp 0.6s ease both">
                <span class="dk-badge sky mb-2" style="font-size: 11px; padding: 4px 10px;">
                    <i class="fas fa-rocket me-1"></i> Interview Prep Platform
                </span>
                <h1 style="font-size:38px;font-weight:900;line-height:1.05;margin-bottom:12px;letter-spacing:-1px">Master Your<br><span style="color:var(--sky-blue)">Next Interview</span></h1>
                <p style="font-size:15px;color:rgba(255,255,255,0.7);max-width:480px;line-height:1.5;margin-bottom:20px">
                    Practice with premium MCQ tests across ColdFusion, JavaScript, and MySQL. Track progress with dark-glass analytics and climb the global leaderboards.
                </p>
                <div class="d-flex gap-3">
                    <a href="#event.buildLink('auth/register')#" class="dk-btn sky" style="padding:10px 22px;font-size:13px">
                        Get Started Free <i class="fas fa-arrow-right ms-2"></i>
                    </a>
                    <a href="##features" class="dk-btn ghost" style="padding:10px 22px;font-size:13px">
                        Learn More
                    </a>
                </div>
                <div class="d-flex gap-4 mt-3 pt-1" style="color:rgba(255,255,255,0.5);font-size:12px">
                    <div><strong style="font-size:18px;color:##fff;display:block">500+</strong>Questions</div>
                    <div><strong style="font-size:18px;color:##fff;display:block">50+</strong>Tests</div>
                    <div><strong style="font-size:18px;color:##fff;display:block">8+</strong>Categories</div>
                </div>
            </div>
            <div class="col-lg-6 text-center" style="animation:fadeSlideUp 0.8s ease 0.2s both">
                <div class="dk-card" style="max-width:390px;margin:0 auto;text-align:left;background:rgba(15,23,42,0.8) !important;border-color:rgba(56,189,248,0.2);padding: 16px;">
                    <div class="d-flex align-items-center gap-2 mb-2">
                        <div style="width:7px;height:7px;border-radius:50%;background:##ef4444"></div>
                        <div style="width:7px;height:7px;border-radius:50%;background:##f59e0b"></div>
                        <div style="width:7px;height:7px;border-radius:50%;background:##22c55e"></div>
                    </div>
                    <div style="font-family:'JetBrains Mono','Fira Code',monospace;font-size:12px;color:rgba(255,255,255,0.9);line-height:1.5">
                        <div style="margin-bottom:8px"><span style="color:var(--sky-blue);font-weight:700">Q:</span> What is a closure in JS??</div>
                        <div style="padding-left:12px;border-left:2px solid rgba(56,189,248,0.2)">
                            <div style="color:rgba(255,255,255,0.4)">A) A loop structure</div>
                            <div style="color:##22c55e;font-weight:600"><i class="fas fa-check-circle me-1"></i> B) A function remembering scope</div>
                            <div style="color:rgba(255,255,255,0.4)">C) An array method</div>
                            <div style="color:rgba(255,255,255,0.4)">D) A class definition</div>
                        </div>
                        <div style="color:##22c55e;margin-top:10px;font-size:10px;opacity:0.8"><i class="fas fa-bolt me-1"></i> Correct! +10xp earned</div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!--- Features Section --->
<section id="features" style="padding:30px 0;position:relative;z-index:1">
    <div class="container">
        <div class="text-center mb-3">
            <h2 style="font-size:26px;font-weight:800;color:##fff;letter-spacing:-0.5px">Ace the <span style="color:var(--sky-blue)">Technical Interview</span></h2>
            <p style="font-size:13px;color:var(--text-muted);max-width:500px;margin:6px auto 0">Premium tools built to push your development career to the next level.</p>
        </div>
        <div class="row g-2">
            <cfset features = [
                {icon:"fa-clipboard-check", title:"Timed MCQ Tests", desc:"Real exam simulation with countdown timer, question palette, and scoring."},
                {icon:"fa-chart-pie", title:"Analytics", desc:"Deep accuracy breakdown, weak area detection, and interactive charts."},
                {icon:"fa-dumbbell", title:"Practice", desc:"Untimed training with instant explanation. Filter by category."},
                {icon:"fa-trophy", title:"Leaderboard", desc:"Compete with top developers and climb the ranks globally."},
                {icon:"fa-code", title:"Code Snippets", desc:"Syntax-highlighted code questions reflecting real interview scenarios."},
                {icon:"fa-star", title:"Premium UI", desc:"Stunning interface with glassmorphism and animated backgrounds."}
            ]>
            <cfloop array="#features#" index="f">
            <div class="col-md-4">
                <div class="dk-card h-100" style="padding:16px">
                    <div style="width:32px;height:32px;border-radius:8px;background:rgba(56,189,248,0.12);display:flex;align-items:center;justify-content:center;margin-bottom:10px">
                        <i class="fas #f.icon#" style="color:var(--sky-blue);font-size:13px"></i>
                    </div>
                    <div style="font-weight:700;font-size:13px;margin-bottom:4px;color:##fff">#f.title#</div>
                    <div style="font-size:11px;color:var(--text-muted);line-height:1.4">#f.desc#</div>
                </div>
            </div>
            </cfloop>
        </div>
    </div>
</section>

<!--- CTA Section --->
<section style="padding:30px 0;background:linear-gradient(to right, rgba(15,23,42,0.8), rgba(56,189,248,0.05));position:relative;z-index:1">
    <div class="container text-center">
        <h2 style="font-size:26px;font-weight:800;margin-bottom:6px;color:##fff">Ready to start your journey?</h2>
        <p style="font-size:13px;color:var(--text-muted);max-width:450px;margin:0 auto 16px">Join the community of developers mastering their skills and landing dream jobs.</p>
        <a href="#event.buildLink('auth/register')#" class="dk-btn sky" style="padding:10px 28px;font-size:14px;font-weight:700">
            Create Free Account <i class="fas fa-arrow-right ms-2"></i>
        </a>
    </div>
</section>
</cfoutput>

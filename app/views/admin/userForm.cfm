<cfoutput>
<div class="page-header" style="animation:fadeSlideUp 0.3s ease both">
    <a href="#event.buildLink('admin/users')#" class="dk-btn ghost mb-3" style="font-size:11px;padding:6px 12px">
        <i class="fas fa-arrow-left me-1"></i> Back to Fleet
    </a>
    <h1 class="page-title"><cfif prc.isEdit>Edit Operative<cfelse>Enlist New Operative</cfif></h1>
    <p class="page-desc">
        <cfif prc.isEdit>Modify details for #prc.targetUser.first_name# (@#prc.targetUser.username#)<cfelse>Add a new account to the platform</cfif>
    </p>
</div>

<div class="row" style="animation:fadeSlideUp 0.4s ease both;animation-delay:0.1s">
    <div class="col-lg-7">
        <div class="dk-card elite" style="padding:32px">
            <form action="#event.buildLink('admin/saveUser')#" method="POST">
                <input type="hidden" name="userId" value="#prc.targetUser.id ?: 0#">
                
                <div class="row g-4">
                    <div class="col-md-6">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">First Name</label>
                        <input type="text" name="firstName" class="form-control" value="#prc.targetUser.first_name#" required placeholder="e.g. John">
                    </div>
                    <div class="col-md-6">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Last Name</label>
                        <input type="text" name="lastName" class="form-control" value="#prc.targetUser.last_name#" required placeholder="e.g. Doe">
                    </div>
                    
                    <div class="col-md-12">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Username</label>
                        <div class="input-group">
                            <span class="input-group-text" style="background:rgba(0,0,0,0.2) !important;border-color:rgba(148,163,184,0.1) !important;color:##64748b">@</span>
                            <input type="text" name="username" class="form-control" value="#prc.targetUser.username#" required placeholder="johndoe" <cfif prc.isEdit>readonly style="background:rgba(0,0,0,0.1) !important;color:rgba(148,163,184,0.5)"</cfif>>
                        </div>
                    </div>

                    <div class="col-md-12">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Email Address</label>
                        <input type="email" name="email" class="form-control" value="#prc.targetUser.email#" required placeholder="john@example.com">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Access Role</label>
                        <select name="roleId" class="form-select">
                            <cfloop query="prc.roles">
                                <option value="#id#" <cfif id EQ prc.targetUser.role_id>selected</cfif>>#name#</option>
                            </cfloop>
                        </select>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">
                            Password <cfif prc.isEdit><small class="ms-1" style="text-transform:none;opacity:0.5;font-weight:400">(Leave blank to keep current)</small></cfif>
                        </label>
                        <input type="password" name="password" class="form-control" <cfif NOT prc.isEdit>required</cfif> placeholder="••••••••">
                    </div>
                </div>

                <div class="mt-5 d-flex gap-3">
                    <button type="submit" class="dk-btn sky px-5" style="background:var(--sky-blue);font-weight:900">
                        <i class="fas fa-shield-check me-2"></i> <cfif prc.isEdit>Save Changes<cfelse>Deploy Account</cfif>
                    </button>
                    <a href="#event.buildLink('admin/users')#" class="dk-btn ghost">Cancel</a>
                </div>
            </form>
        </div>
    </div>
    <div class="col-lg-5">
        <div class="dk-card" style="background:rgba(56,189,248,0.02);border-style:dashed;padding:28px">
            <h6 style="color:##fff;font-weight:800;margin-bottom:16px;display:flex;align-items:center;gap:10px">
                <i class="fas fa-user-shield" style="color:var(--sky-blue)"></i> Security Briefing
            </h6>
            <div style="font-size:13px;color:rgba(148,163,184,0.7);line-height:1.7">
                <p>Ensure each operative has the appropriate access level. Administrative roles allow full control over platform parameters and question bank stability.</p>
                <ul class="ps-3 mt-3">
                    <li class="mb-2"><strong>Admin:</strong> Full access to system configs, user management, and intel streams.</li>
                    <li><strong>User:</strong> Standard access to testing modules and performance logs.</li>
                </ul>
            </div>
        </div>
    </div>
</div>
</cfoutput>

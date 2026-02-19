<cfoutput>
<div class="page-header">
    <h1 class="page-title">Users</h1>
    <p class="page-desc">Manage platform users</p>
</div>

<div class="d-flex justify-content-end mb-3" style="animation:fadeSlideUp 0.3s ease both">
    <a href="#event.buildLink('admin/createUser')#" class="dk-btn sky">
        <i class="fas fa-plus"></i> Add User
    </a>
</div>

<div class="dk-table-wrap">
    <table class="table">
        <thead>
            <tr style="font-size:11px;text-transform:uppercase;letter-spacing:1px;color:rgba(148,163,184,0.4)">
                <th class="ps-4">Operative</th>
                <th>Email</th>
                <th>Access Level</th>
                <th>Status</th>
                <th>Enrolled</th>
                <th class="pe-4 text-end">Actions</th>
            </tr>
        </thead>
        <tbody>
            <cfloop query="prc.users">
                <tr style="transition:all 0.3s;border-color:rgba(148,163,184,0.03)" onmouseover="this.style.background='rgba(56,189,248,0.02)'" onmouseout="this.style.background='transparent'">
                    <td class="ps-4 py-3">
                        <div class="d-flex align-items-center gap-3">
                            <div class="dk-avatar" style="width:34px;height:34px;background:rgba(56,189,248,0.1);color:var(--sky-blue);font-weight:900;border-radius:10px;display:flex;align-items:center;justify-content:center">#uCase(left(username, 1))#</div>
                            <div>
                                <div style="font-weight:700;color:##fff;font-size:14px">#first_name# #last_name#</div>
                                <div style="color:rgba(148,163,184,0.5);font-size:11px;font-weight:600">@#username#</div>
                            </div>
                        </div>
                    </td>
                    <td style="color:rgba(148,163,184,0.7);font-size:13px">#email#</td>
                    <td>
                        <span class="dk-badge <cfif role_name EQ 'Admin'>sky<cfelse>slate</cfif>" style="font-family:monospace;font-size:10px;font-weight:800;letter-spacing:0.5px">#role_name#</span>
                    </td>
                    <td>
                        <span class="dk-badge <cfif is_active>green<cfelse>red</cfif>" style="font-size:10px;font-weight:800;letter-spacing:0.5px">
                            <i class="fas fa-circle me-1" style="font-size:6px;vertical-align:middle"></i>
                            <cfif is_active>ACTIVE<cfelse>LOCKED</cfif>
                        </span>
                    </td>
                    <td style="color:rgba(148,163,184,0.5);font-size:12px;font-weight:600">#dateFormat(created_at, "dd MMM yyyy")#</td>
                    <td class="pe-4 py-3 text-end">
                        <div class="d-flex gap-1 justify-content-end">
                            <a href="#event.buildLink('admin/editUser')#?userId=#id#" class="dk-btn-icon" title="Edit Profile">
                                <span style="font-size:14px">📝</span>
                            </a>
                            <a href="#event.buildLink('admin/toggleUser')#?userId=#id#" 
                               class="dk-btn-icon <cfif is_active>amber<cfelse>green</cfif>" title="<cfif is_active>Revoke Access<cfelse>Grant Access</cfif>">
                                <cfif is_active><span style="font-size:14px">🚫</span><cfelse><span style="font-size:14px">🔓</span></cfif>
                            </a>
                            <button class="bg-transparent border-0 p-0 ms-2"
                                    onclick="confirmDelete('Remove operative #jsStringFormat(username)# permanently?', '#event.buildLink('admin/deleteUser')#?userId=#id#')" title="Terminate Account" style="cursor:pointer">
                                <span style="font-size:14px">🗑️</span>
                            </button>
                        </div>
                    </td>
                </tr>
            </cfloop>
        </tbody>
    </table>
</div>
</cfoutput>

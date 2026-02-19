<cfoutput>
<div class="page-header">
    <h1 class="page-title">Categories</h1>
    <p class="page-desc">Manage question categories</p>
</div>

<div class="d-flex justify-content-end mb-3" style="animation:fadeSlideUp 0.3s ease both">
    <button class="dk-btn sky" data-bs-toggle="modal" data-bs-target="##categoryModal" onclick="resetCategoryForm()">
        <i class="fas fa-plus"></i> Add Category
    </button>
</div>

<div class="row g-3">
    <cfloop query="prc.categories">
    <div class="col-md-6 col-lg-4 col-xl-3" style="animation:fadeSlideUp 0.4s ease both;animation-delay:#(currentRow * 0.05)#s">
        <div class="dk-card elite h-100 d-flex flex-column" style="padding:18px">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div style="width:42px;height:42px;border-radius:12px;background:rgba(56,189,248,0.1);display:flex;align-items:center;justify-content:center;font-size:20px;filter:drop-shadow(0 0-8px rgba(56,189,248,0.2))">
                    <cfif name CONTAINS "ColdFusion">🧪<cfelseif name CONTAINS "JS" OR name CONTAINS "Java">⚡<cfelseif name CONTAINS "SQL">📑<cfelseif name CONTAINS "Coding">💻<cfelse>🔋</cfif>
                </div>
                <div class="dropdown">
                    <button class="dk-btn ghost" data-bs-toggle="dropdown" style="padding:6px 10px;border-radius:8px;border:none">
                        <i class="fas fa-ellipsis-h" style="opacity:0.5;font-size:12px"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end">
                        <li>
                            <a class="dropdown-item" href="##" onclick="editCategory(#id#, '#jsStringFormat(name)#', '#jsStringFormat(slug)#', '#jsStringFormat(description)#', '#jsStringFormat(icon)#', '#jsStringFormat(color)#')">
                                <span class="me-2">📝</span> Update Intel
                            </a>
                        </li>
                        <li><hr class="dropdown-divider"></li>
                        <li>
                            <a class="dropdown-item text-danger" href="##" onclick="confirmDelete('Archive Category #jsStringFormat(name)#?', '#event.buildLink('admin/deleteCategory')#?categoryId=#id#')">
                                <span class="me-2">🗑️</span> Shutdown
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <div style="font-weight:900;font-size:16px;color:##fff;margin-bottom:6px;letter-spacing:-0.5px">#name#</div>
            <p style="color:rgba(148,163,184,0.6);font-size:12px;margin-bottom:18px;line-height:1.5;flex:1">
                #description#
            </p>
            
            <div class="d-flex align-items-center justify-content-between pt-3 mt-auto" style="border-top:1px solid rgba(148,163,184,0.05)">
                <span class="dk-badge slate" style="background:rgba(148,163,184,0.06);font-weight:800;letter-spacing:0.5px;font-size:9px">💎 #question_count# ITEMS</span>
                <a href="#event.buildLink('admin/questions')#?categoryId=#id#" class="dk-btn ghost" style="padding:5px 10px;font-size:10px;font-weight:800;background:rgba(56,189,248,0.05);color:var(--sky-blue)">
                    ACCESS Questions <i class="fas fa-arrow-right ms-1"></i>
                </a>
            </div>
        </div>
    </div>
    </cfloop>
</div>


<!--- Category Modal --->
<div class="modal fade" id="categoryModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background:rgba(15,23,42,0.95);backdrop-filter:blur(24px);border:1px solid rgba(56,189,248,0.15);border-radius:24px;box-shadow:0 24px 64px rgba(0,0,0,0.4)">
            <div class="modal-header border-0 p-4 pb-0">
                <h5 class="modal-title" style="font-weight:800;font-size:20px;color:##fff" id="categoryModalTitle">Add Category</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>
            <form action="#event.buildLink('admin/saveCategory')#" method="POST">
                <div class="modal-body p-4">
                    <input type="hidden" name="categoryId" id="catId" value="0">
                    <div class="field mb-4">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Category Name</label>
                        <input type="text" name="name" id="catName" class="form-control" placeholder="e.g. Frontend Development" required style="padding:12px;font-size:14px">
                    </div>
                    <div class="field mb-4">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Url Slug</label>
                        <input type="text" name="slug" id="catSlug" class="form-control" placeholder="auto-generated" style="padding:12px;font-size:14px;background:rgba(0,0,0,0.2) !important">
                    </div>
                    <div class="field mb-4">
                        <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Description</label>
                        <textarea name="description" id="catDesc" class="form-control" rows="3" placeholder="Briefly describe what this category covers..." style="padding:12px;font-size:14px"></textarea>
                    </div>
                    <div class="row g-3">
                        <div class="col-6">
                            <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Icon Class</label>
                            <input type="text" name="icon" id="catIcon" class="form-control" value="fa-code" placeholder="fa-code" style="padding:12px;font-size:14px">
                        </div>
                        <div class="col-6">
                            <label class="form-label" style="font-size:11px;font-weight:700;color:##94a3b8;text-transform:uppercase;letter-spacing:1px">Accent Color</label>
                            <input type="color" name="color" id="catColor" class="form-control form-control-color w-100" style="height:48px;padding:6px;border-radius:10px" value="##38bdf8">
                        </div>
                    </div>
                </div>
                <div class="modal-footer border-0 p-4 pt-0">
                    <button type="button" class="dk-btn ghost w-100 py-3 mb-2" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="dk-btn sky w-100 py-3" style="background:var(--sky-blue);font-weight:800"><i class="fas fa-save me-2"></i> Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
function resetCategoryForm() {
    document.getElementById('categoryModalTitle').textContent = 'Add Category';
    document.getElementById('catId').value = 0;
    document.getElementById('catName').value = '';
    document.getElementById('catSlug').value = '';
    document.getElementById('catDesc').value = '';
    document.getElementById('catIcon').value = 'fa-code';
    document.getElementById('catColor').value = '##38bdf8';
}

function editCategory(id, name, slug, desc, icon, color) {
    document.getElementById('categoryModalTitle').textContent = 'Edit Category';
    document.getElementById('catId').value = id;
    document.getElementById('catName').value = name;
    document.getElementById('catSlug').value = slug;
    document.getElementById('catDesc').value = desc;
    document.getElementById('catIcon').value = icon;
    document.getElementById('catColor').value = color;
    new bootstrap.Modal(document.getElementById('categoryModal')).show();
}
</script>
</cfoutput>

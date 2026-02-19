/**
 * CategoryService — CRUD for question categories.
 */
component singleton accessors="true" {

    /**
     * Get all categories
     */
    function getAllCategories() {
        return queryExecute(
            "SELECT c.*, (SELECT COUNT(*) FROM questions WHERE category_id = c.id AND is_active = 1) as question_count
             FROM categories c
             ORDER BY c.sort_order, c.name",
            {},
            { datasource: "stddb" }
        );
    }

    /**
     * Get active categories only
     */
    function getActiveCategories() {
        return queryExecute(
            "SELECT c.*, (SELECT COUNT(*) FROM questions WHERE category_id = c.id AND is_active = 1) as question_count
             FROM categories c
             WHERE c.is_active = 1
             ORDER BY c.sort_order, c.name",
            {},
            { datasource: "stddb" }
        );
    }

    /**
     * Get category by ID
     */
    function getCategoryById( required numeric categoryId ) {
        return queryExecute(
            "SELECT * FROM categories WHERE id = :id",
            { id: arguments.categoryId },
            { datasource: "stddb" }
        );
    }

    /**
     * Create a category
     */
    function createCategory( required string name, required string slug,
                              string description = "", string icon = "fa-code",
                              string color = "##6366f1", numeric sortOrder = 0 ) {
        queryExecute(
            "INSERT INTO categories (name, slug, description, icon, color, sort_order)
             VALUES (:name, :slug, :description, :icon, :color, :sortOrder)",
            {
                name:        arguments.name,
                slug:        arguments.slug,
                description: arguments.description,
                icon:        arguments.icon,
                color:       arguments.color,
                sortOrder:   arguments.sortOrder
            },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Update a category
     */
    function updateCategory( required numeric categoryId, required string name,
                              required string slug, string description = "",
                              string icon = "fa-code", string color = "##6366f1" ) {
        queryExecute(
            "UPDATE categories SET name = :name, slug = :slug, description = :description,
                    icon = :icon, color = :color
             WHERE id = :id",
            {
                id:          arguments.categoryId,
                name:        arguments.name,
                slug:        arguments.slug,
                description: arguments.description,
                icon:        arguments.icon,
                color:       arguments.color
            },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Delete a category (only if no questions reference it)
     */
    function deleteCategory( required numeric categoryId ) {
        var check = queryExecute(
            "SELECT COUNT(*) as cnt FROM questions WHERE category_id = :id",
            { id: arguments.categoryId },
            { datasource: "stddb" }
        );
        if ( check.cnt > 0 ) {
            return { "success": false, "message": "Cannot delete — category has #check.cnt# questions." };
        }
        queryExecute(
            "DELETE FROM categories WHERE id = :id",
            { id: arguments.categoryId },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Get difficulty levels
     */
    function getDifficultyLevels() {
        return queryExecute(
            "SELECT * FROM difficulty_levels ORDER BY id",
            {},
            { datasource: "stddb" }
        );
    }

}

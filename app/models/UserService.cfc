/**
 * UserService — handles user registration, authentication, and management.
 * Injected via WireBox as a singleton.
 */
component singleton accessors="true" {

    /**
     * Register a new user
     */
    function register( required string username, required string email, required string password,
                        string firstName = "", string lastName = "", numeric roleId = 2 ) {

        // Check if username or email already exists
        var existing = queryExecute(
            "SELECT id FROM users WHERE username = :username OR email = :email",
            { username: arguments.username, email: arguments.email },
            { datasource: "stddb" }
        );
        if ( existing.recordCount ) {
            return { "success": false, "message": "Username or email already exists." };
        }

        // Hash password using SHA-256 for BoxLang compatibility
        var hashedPassword = hash( arguments.password, "SHA-256" );

        queryExecute(
            "INSERT INTO users (username, email, password_hash, first_name, last_name, role_id)
             VALUES (:username, :email, :password_hash, :first_name, :last_name, :role_id)",
            {
                username:      arguments.username,
                email:         arguments.email,
                password_hash: hashedPassword,
                first_name:    arguments.firstName,
                last_name:     arguments.lastName,
                role_id:       arguments.roleId
            },
            { datasource: "stddb" }
        );

        // Get the newly created user
        var newUser = queryExecute(
            "SELECT id FROM users WHERE username = :username",
            { username: arguments.username },
            { datasource: "stddb" }
        );

        // Initialize leaderboard entry
        queryExecute(
            "INSERT INTO leaderboard (user_id) VALUES (:userId)",
            { userId: newUser.id },
            { datasource: "stddb" }
        );

        return { "success": true, "message": "Registration successful!", "userId": newUser.id };
    }

    /**
     * Authenticate a user
     */
    function authenticate( required string username, required string password ) {
        var hashedPassword = hash( arguments.password, "SHA-256" );

        var user = queryExecute(
            "SELECT u.id, u.username, u.email, u.first_name, u.last_name, u.role_id, u.avatar, u.is_active,
                    r.name as role_name
             FROM users u
             JOIN roles r ON u.role_id = r.id
             WHERE (u.username = :username OR u.email = :username)
               AND u.password_hash = :password_hash
               AND u.is_active = 1",
            { username: arguments.username, password_hash: hashedPassword },
            { datasource: "stddb" }
        );

        if ( user.recordCount ) {
            // Update last login
            queryExecute(
                "UPDATE users SET last_login = NOW() WHERE id = :id",
                { id: user.id },
                { datasource: "stddb" }
            );
            return {
                "success":   true,
                "user": {
                    "id":        user.id,
                    "username":  user.username,
                    "email":     user.email,
                    "firstName": user.first_name,
                    "lastName":  user.last_name,
                    "roleId":    user.role_id,
                    "roleName":  user.role_name,
                    "avatar":    user.avatar
                }
            };
        }

        return { "success": false, "message": "Invalid credentials or account is inactive." };
    }

    /**
     * Get user by ID
     */
    function getUserById( required numeric userId ) {
        var user = queryExecute(
            "SELECT u.*, r.name as role_name
             FROM users u
             JOIN roles r ON u.role_id = r.id
             WHERE u.id = :id",
            { id: arguments.userId },
            { datasource: "stddb" }
        );
        return user;
    }

    /**
     * Get all users (admin)
     */
    function getAllUsers() {
        return queryExecute(
            "SELECT u.id, u.username, u.email, u.first_name, u.last_name, u.is_active,
                    u.last_login, u.created_at, r.name as role_name
             FROM users u
             JOIN roles r ON u.role_id = r.id
             ORDER BY u.created_at DESC",
            {},
            { datasource: "stddb" }
        );
    }

    /**
     * Toggle user active status (admin)
     */
    function toggleUserStatus( required numeric userId ) {
        queryExecute(
            "UPDATE users SET is_active = NOT is_active WHERE id = :id",
            { id: arguments.userId },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Update user profile
     */
    function updateProfile( required numeric userId, required string firstName,
                            required string lastName, required string email ) {
        queryExecute(
            "UPDATE users SET first_name = :firstName, last_name = :lastName, email = :email WHERE id = :id",
            { firstName: arguments.firstName, lastName: arguments.lastName, email: arguments.email, id: arguments.userId },
            { datasource: "stddb" }
        );
        return { "success": true };
    }

    /**
     * Get all roles
     */
    function getRoles() {
        return queryExecute(
            "SELECT id, name FROM roles ORDER BY id ASC",
            {},
            { datasource: "stddb" }
        );
    }

    /**
     * Update user (admin)
     */
    function updateUser( required numeric userId, required string username, required string email,
                         required string firstName, required string lastName, required numeric roleId,
                         string password = "" ) {
        
        var params = {
            username:  arguments.username,
            email:     arguments.email,
            firstName: arguments.firstName,
            lastName:  arguments.lastName,
            roleId:    arguments.roleId,
            id:        arguments.userId
        };

        var sql = "UPDATE users SET username = :username, email = :email, first_name = :firstName, last_name = :lastName, role_id = :roleId";

        if ( len(trim(arguments.password)) ) {
            params.password_hash = hash( arguments.password, "SHA-256" );
            sql &= ", password_hash = :password_hash";
        }

        sql &= " WHERE id = :id";

        queryExecute( sql, params, { datasource: "stddb" } );
        return { "success": true };
    }

    /**
     * Delete user (admin)
     */
    function deleteUser( required numeric userId ) {
        // First delete from leaderboard
        queryExecute( "DELETE FROM leaderboard WHERE user_id = :id", { id: arguments.userId }, { datasource: "stddb" } );
        // Then delete results
        queryExecute( "DELETE FROM results WHERE user_id = :id", { id: arguments.userId }, { datasource: "stddb" } );
        // Finally delete user
        queryExecute( "DELETE FROM users WHERE id = :id", { id: arguments.userId }, { datasource: "stddb" } );
        
        return { "success": true };
    }

    /**
     * Get total user count
     */
    function getUserCount() {
        var result = queryExecute(
            "SELECT COUNT(*) as cnt FROM users",
            {},
            { datasource: "stddb" }
        );
        return result.cnt;
    }

}

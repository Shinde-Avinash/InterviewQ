-- ============================================================
-- Interview Prep & MCQ Test Platform — Database Schema
-- Database: stddb | User: avi10 | Engine: InnoDB
-- ============================================================

SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------------
-- 1. ROLES
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `roles`;
CREATE TABLE `roles` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(50)  NOT NULL,
    `description` VARCHAR(255) DEFAULT NULL,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_roles_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 2. USERS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
    `id`            INT UNSIGNED  NOT NULL AUTO_INCREMENT,
    `username`      VARCHAR(100)  NOT NULL,
    `email`         VARCHAR(255)  NOT NULL,
    `password_hash` VARCHAR(255)  NOT NULL,
    `first_name`    VARCHAR(100)  DEFAULT NULL,
    `last_name`     VARCHAR(100)  DEFAULT NULL,
    `role_id`       INT UNSIGNED  NOT NULL DEFAULT 2,
    `avatar`        VARCHAR(500)  DEFAULT NULL,
    `is_active`     TINYINT(1)    NOT NULL DEFAULT 1,
    `last_login`    DATETIME      DEFAULT NULL,
    `created_at`    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_users_username` (`username`),
    UNIQUE KEY `uk_users_email` (`email`),
    KEY `idx_users_role` (`role_id`),
    KEY `idx_users_active` (`is_active`),
    CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) REFERENCES `roles`(`id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 3. CATEGORIES
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `name`        VARCHAR(100) NOT NULL,
    `slug`        VARCHAR(120) NOT NULL,
    `description` VARCHAR(500) DEFAULT NULL,
    `icon`        VARCHAR(100) DEFAULT 'fa-code',
    `color`       VARCHAR(20)  DEFAULT '#6366f1',
    `is_active`   TINYINT(1)   NOT NULL DEFAULT 1,
    `sort_order`  INT          NOT NULL DEFAULT 0,
    `created_at`  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_categories_slug` (`slug`),
    KEY `idx_categories_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 4. DIFFICULTY LEVELS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `difficulty_levels`;
CREATE TABLE `difficulty_levels` (
    `id`         INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    `name`       VARCHAR(50)    NOT NULL,
    `multiplier` DECIMAL(3,2)   NOT NULL DEFAULT 1.00,
    `color`      VARCHAR(20)    DEFAULT '#22c55e',
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_difficulty_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 5. QUESTIONS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
    `id`            INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_id`   INT UNSIGNED NOT NULL,
    `difficulty_id` INT UNSIGNED NOT NULL DEFAULT 1,
    `question_text` TEXT         NOT NULL,
    `code_snippet`  TEXT         DEFAULT NULL,
    `explanation`   TEXT         DEFAULT NULL,
    `is_active`     TINYINT(1)  NOT NULL DEFAULT 1,
    `created_by`    INT UNSIGNED DEFAULT NULL,
    `created_at`    TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`    TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_questions_category` (`category_id`),
    KEY `idx_questions_difficulty` (`difficulty_id`),
    KEY `idx_questions_active` (`is_active`),
    CONSTRAINT `fk_questions_category`   FOREIGN KEY (`category_id`)   REFERENCES `categories`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_questions_difficulty` FOREIGN KEY (`difficulty_id`) REFERENCES `difficulty_levels`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_questions_creator`    FOREIGN KEY (`created_by`)    REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 6. QUESTION OPTIONS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `question_options`;
CREATE TABLE `question_options` (
    `id`          INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `question_id` INT UNSIGNED NOT NULL,
    `option_text` TEXT         NOT NULL,
    `is_correct`  TINYINT(1)  NOT NULL DEFAULT 0,
    `sort_order`  INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_options_question` (`question_id`),
    CONSTRAINT `fk_options_question` FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 7. TESTS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `tests`;
CREATE TABLE `tests` (
    `id`                  INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title`               VARCHAR(255) NOT NULL,
    `description`         TEXT         DEFAULT NULL,
    `category_id`         INT UNSIGNED DEFAULT NULL,
    `difficulty_id`       INT UNSIGNED DEFAULT NULL,
    `total_questions`     INT          NOT NULL DEFAULT 10,
    `duration_minutes`    INT          NOT NULL DEFAULT 15,
    `negative_marking`    TINYINT(1)   NOT NULL DEFAULT 0,
    `negative_mark_value` DECIMAL(3,2) NOT NULL DEFAULT 0.25,
    `pass_percentage`     INT          NOT NULL DEFAULT 40,
    `is_practice`         TINYINT(1)   NOT NULL DEFAULT 0,
    `is_active`           TINYINT(1)   NOT NULL DEFAULT 1,
    `created_by`          INT UNSIGNED DEFAULT NULL,
    `created_at`          TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    KEY `idx_tests_category` (`category_id`),
    KEY `idx_tests_active` (`is_active`),
    CONSTRAINT `fk_tests_category`   FOREIGN KEY (`category_id`)   REFERENCES `categories`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_tests_difficulty` FOREIGN KEY (`difficulty_id`) REFERENCES `difficulty_levels`(`id`) ON UPDATE CASCADE,
    CONSTRAINT `fk_tests_creator`    FOREIGN KEY (`created_by`)    REFERENCES `users`(`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 8. TEST ATTEMPTS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `test_attempts`;
CREATE TABLE `test_attempts` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `test_id`            INT UNSIGNED NOT NULL,
    `user_id`            INT UNSIGNED NOT NULL,
    `started_at`         DATETIME     NOT NULL,
    `finished_at`        DATETIME     DEFAULT NULL,
    `score`              DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    `total_marks`        DECIMAL(8,2) NOT NULL DEFAULT 0.00,
    `percentage`         DECIMAL(5,2) NOT NULL DEFAULT 0.00,
    `correct_answers`    INT          NOT NULL DEFAULT 0,
    `wrong_answers`      INT          NOT NULL DEFAULT 0,
    `unanswered`         INT          NOT NULL DEFAULT 0,
    `status`             ENUM('in_progress','completed','abandoned') NOT NULL DEFAULT 'in_progress',
    `time_taken_seconds` INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_attempts_test` (`test_id`),
    KEY `idx_attempts_user` (`user_id`),
    KEY `idx_attempts_status` (`status`),
    CONSTRAINT `fk_attempts_test` FOREIGN KEY (`test_id`) REFERENCES `tests`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_attempts_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 9. ATTEMPT ANSWERS
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `attempt_answers`;
CREATE TABLE `attempt_answers` (
    `id`                 INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `attempt_id`         INT UNSIGNED NOT NULL,
    `question_id`        INT UNSIGNED NOT NULL,
    `selected_option_id` INT UNSIGNED DEFAULT NULL,
    `is_correct`         TINYINT(1)   DEFAULT NULL,
    `is_bookmarked`      TINYINT(1)   NOT NULL DEFAULT 0,
    `time_spent_seconds` INT          NOT NULL DEFAULT 0,
    PRIMARY KEY (`id`),
    KEY `idx_answers_attempt` (`attempt_id`),
    KEY `idx_answers_question` (`question_id`),
    CONSTRAINT `fk_answers_attempt`  FOREIGN KEY (`attempt_id`)  REFERENCES `test_attempts`(`id`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_answers_question` FOREIGN KEY (`question_id`) REFERENCES `questions`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------
-- 10. LEADERBOARD
-- -----------------------------------------------------------
DROP TABLE IF EXISTS `leaderboard`;
CREATE TABLE `leaderboard` (
    `id`             INT UNSIGNED   NOT NULL AUTO_INCREMENT,
    `user_id`        INT UNSIGNED   NOT NULL,
    `total_score`    DECIMAL(10,2)  NOT NULL DEFAULT 0.00,
    `tests_taken`    INT            NOT NULL DEFAULT 0,
    `avg_percentage` DECIMAL(5,2)   NOT NULL DEFAULT 0.00,
    `best_score`     DECIMAL(5,2)   NOT NULL DEFAULT 0.00,
    `current_streak` INT            NOT NULL DEFAULT 0,
    `max_streak`     INT            NOT NULL DEFAULT 0,
    `rank_position`  INT            NOT NULL DEFAULT 0,
    `updated_at`     TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`),
    UNIQUE KEY `uk_leaderboard_user` (`user_id`),
    KEY `idx_leaderboard_rank` (`rank_position`),
    KEY `idx_leaderboard_score` (`total_score` DESC),
    CONSTRAINT `fk_leaderboard_user` FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

SET FOREIGN_KEY_CHECKS = 1;

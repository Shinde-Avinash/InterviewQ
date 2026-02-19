-- ============================================================
-- Interview Prep & MCQ Test Platform — Seed Data
-- ============================================================

-- -----------------------------------------------------------
-- ROLES
-- -----------------------------------------------------------
INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'Admin',   'Full platform access — manage questions, users, and settings'),
(2, 'Student', 'Take tests, practice, view results and leaderboard');

-- -----------------------------------------------------------
-- DIFFICULTY LEVELS
-- -----------------------------------------------------------
INSERT INTO `difficulty_levels` (`id`, `name`, `multiplier`, `color`) VALUES
(1, 'Easy',     1.00, '#22c55e'),
(2, 'Medium',   1.50, '#f59e0b'),
(3, 'Hard',     2.00, '#ef4444'),
(4, 'Expert',   3.00, '#7c3aed');

-- -----------------------------------------------------------
-- CATEGORIES
-- -----------------------------------------------------------
INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `icon`, `color`, `sort_order`) VALUES
(1, 'ColdFusion',      'coldfusion',      'Adobe ColdFusion / CFML fundamentals and advanced topics',   'fa-fire',           '#e04e39', 1),
(2, 'ColdBox',         'coldbox',         'ColdBox MVC framework — handlers, services, ORM, modules',   'fa-box',            '#1e40af', 2),
(3, 'MySQL',           'mysql',           'MySQL queries, joins, indexes, stored procedures',            'fa-database',       '#00758f', 3),
(4, 'JavaScript',      'javascript',      'ES6+, DOM, async/await, closures, prototypes',               'fa-js',             '#f7df1e', 4),
(5, 'HTML & CSS',      'html-css',        'Semantic HTML5, CSS3, Flexbox, Grid, responsiveness',         'fa-code',           '#e44d26', 5),
(6, 'SQL',             'sql',             'General SQL — DDL, DML, joins, subqueries, aggregations',     'fa-table',          '#336791', 6),
(7, 'OOP Concepts',    'oop',             'Object-Oriented Programming — SOLID, design patterns',       'fa-cubes',          '#6366f1', 7),
(8, 'Data Structures', 'data-structures', 'Arrays, linked lists, trees, graphs, hash tables',           'fa-project-diagram','#0ea5e9', 8);

-- -----------------------------------------------------------
-- ADMIN USER  (password: admin123)
-- Using SHA-256 hash for compatibility; in production use bcrypt
-- Hash of 'admin123' = SHA-256 placeholder — the app will use hash() function
-- -----------------------------------------------------------
INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `first_name`, `last_name`, `role_id`) VALUES
(1, 'admin', 'admin@interviewprep.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', 'Admin', 'User', 1);

-- -----------------------------------------------------------
-- DEMO STUDENT  (password: student123)
-- -----------------------------------------------------------
INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `first_name`, `last_name`, `role_id`) VALUES
(2, 'student', 'student@interviewprep.com', 'a]665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'Demo', 'Student', 2);

-- -----------------------------------------------------------
-- SAMPLE QUESTIONS — ColdFusion (category_id = 1)
-- -----------------------------------------------------------
INSERT INTO `questions` (`category_id`, `difficulty_id`, `question_text`, `code_snippet`, `explanation`, `created_by`) VALUES
(1, 1, 'Which tag is used to define a ColdFusion component?', NULL,
 'The <cfcomponent> tag (or the component keyword in cfscript) is used to define a ColdFusion Component (CFC).', 1),

(1, 1, 'What is the default scope for variables declared inside a CFC method?', NULL,
 'Variables declared inside a CFC method default to the "variables" scope, which is private to the component instance.', 1),

(1, 2, 'What does the <cfqueryparam> tag do?', NULL,
 'The <cfqueryparam> tag binds parameters to a query, preventing SQL injection and improving query performance through type checking.', 1),

(1, 2, 'Which function is used to serialize a ColdFusion struct to JSON?', NULL,
 'serializeJSON() converts any ColdFusion value (struct, array, query) into a JSON string.', 1),

(1, 3, 'What is the purpose of the onMissingMethod() function in a CFC?',
 'component {\n  function onMissingMethod(missingMethodName, missingMethodArguments) {\n    // handle dynamic calls\n  }\n}',
 'onMissingMethod() is a special interceptor that gets called when a method is invoked on a CFC that does not exist. It enables dynamic method handling.', 1);

-- Options for ColdFusion Q1
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(1, '<cfcomponent>', 1, 1),
(1, '<cfclass>', 0, 2),
(1, '<cfobject>', 0, 3),
(1, '<cfmodule>', 0, 4);

-- Options for ColdFusion Q2
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(2, 'local scope', 0, 1),
(2, 'variables scope', 1, 2),
(2, 'this scope', 0, 3),
(2, 'request scope', 0, 4);

-- Options for ColdFusion Q3
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(3, 'Formats query output', 0, 1),
(3, 'Prevents SQL injection by binding parameters', 1, 2),
(3, 'Caches query results', 0, 3),
(3, 'Limits the number of rows returned', 0, 4);

-- Options for ColdFusion Q4
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(4, 'toJSON()', 0, 1),
(4, 'structToJSON()', 0, 2),
(4, 'serializeJSON()', 1, 3),
(4, 'jsonEncode()', 0, 4);

-- Options for ColdFusion Q5
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(5, 'It logs missing method calls', 0, 1),
(5, 'It handles calls to undefined methods dynamically', 1, 2),
(5, 'It prevents errors from missing methods', 0, 3),
(5, 'It auto-generates method stubs', 0, 4);

-- -----------------------------------------------------------
-- SAMPLE QUESTIONS — JavaScript (category_id = 4)
-- -----------------------------------------------------------
INSERT INTO `questions` (`category_id`, `difficulty_id`, `question_text`, `code_snippet`, `explanation`, `created_by`) VALUES
(4, 1, 'Which keyword is used to declare a constant in JavaScript?', NULL,
 'The "const" keyword declares a block-scoped constant whose value cannot be reassigned after initialization.', 1),

(4, 1, 'What does the === operator do in JavaScript?', NULL,
 'The strict equality operator (===) checks both value and type, unlike == which performs type coercion.', 1),

(4, 2, 'What is a closure in JavaScript?',
 'function outer() {\n  let count = 0;\n  return function inner() {\n    count++;\n    return count;\n  };\n}',
 'A closure is a function that remembers the variables from its outer (enclosing) scope even after the outer function has finished executing.', 1),

(4, 2, 'What is the output of: typeof null?', 'console.log(typeof null);',
 'typeof null returns "object", which is a well-known bug in JavaScript that has persisted since the first version.', 1),

(4, 3, 'What is the event loop in JavaScript?', NULL,
 'The event loop is a mechanism that allows JavaScript to perform non-blocking I/O operations. It continuously checks the call stack and processes the callback/microtask queues when the stack is empty.', 1);

-- Options for JS Q1 (id=6)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(6, 'var', 0, 1),
(6, 'let', 0, 2),
(6, 'const', 1, 3),
(6, 'static', 0, 4);

-- Options for JS Q2 (id=7)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(7, 'Checks value only', 0, 1),
(7, 'Checks type only', 0, 2),
(7, 'Checks both value and type', 1, 3),
(7, 'Assigns a value', 0, 4);

-- Options for JS Q3 (id=8)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(8, 'A function inside a loop', 0, 1),
(8, 'A function that remembers its outer scope variables', 1, 2),
(8, 'A self-invoking function', 0, 3),
(8, 'An arrow function', 0, 4);

-- Options for JS Q4 (id=9)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(9, '"null"', 0, 1),
(9, '"undefined"', 0, 2),
(9, '"object"', 1, 3),
(9, '"number"', 0, 4);

-- Options for JS Q5 (id=10)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(10, 'A design pattern for loops', 0, 1),
(10, 'A mechanism for non-blocking async execution', 1, 2),
(10, 'A browser rendering engine', 0, 3),
(10, 'A type of for loop', 0, 4);

-- -----------------------------------------------------------
-- SAMPLE QUESTIONS — MySQL (category_id = 3)
-- -----------------------------------------------------------
INSERT INTO `questions` (`category_id`, `difficulty_id`, `question_text`, `code_snippet`, `explanation`, `created_by`) VALUES
(3, 1, 'Which SQL clause is used to filter rows?', NULL,
 'The WHERE clause filters rows based on a specified condition before grouping.', 1),

(3, 2, 'What is the difference between WHERE and HAVING?',
 'SELECT dept, COUNT(*) FROM emp\nWHERE salary > 50000\nGROUP BY dept\nHAVING COUNT(*) > 5;',
 'WHERE filters individual rows before grouping. HAVING filters groups after the GROUP BY aggregation.', 1),

(3, 2, 'Which JOIN returns all rows from both tables, matching where possible?', NULL,
 'A FULL OUTER JOIN returns all rows from both tables, with NULLs where there is no match. MySQL doesn''t support it directly but it can be emulated with UNION.', 1),

(3, 3, 'What is a covering index?', NULL,
 'A covering index is an index that contains all the columns needed to satisfy a query, so MySQL can return results directly from the index without accessing the table data.', 1),

(3, 1, 'Which keyword removes duplicate rows from query results?', NULL,
 'The DISTINCT keyword eliminates duplicate rows from the result set.', 1);

-- Options for MySQL Q1 (id=11)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(11, 'GROUP BY', 0, 1),
(11, 'WHERE', 1, 2),
(11, 'ORDER BY', 0, 3),
(11, 'HAVING', 0, 4);

-- Options for MySQL Q2 (id=12)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(12, 'WHERE filters before grouping, HAVING filters after', 1, 1),
(12, 'They are identical', 0, 2),
(12, 'HAVING filters before grouping, WHERE after', 0, 3),
(12, 'WHERE works only with JOINs', 0, 4);

-- Options for MySQL Q3 (id=13)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(13, 'INNER JOIN', 0, 1),
(13, 'LEFT JOIN', 0, 2),
(13, 'FULL OUTER JOIN', 1, 3),
(13, 'CROSS JOIN', 0, 4);

-- Options for MySQL Q4 (id=14)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(14, 'An index on the primary key only', 0, 1),
(14, 'An index that covers all columns a query needs', 1, 2),
(14, 'An index on every column in a table', 0, 3),
(14, 'A unique index', 0, 4);

-- Options for MySQL Q5 (id=15)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(15, 'UNIQUE', 0, 1),
(15, 'DISTINCT', 1, 2),
(15, 'FILTER', 0, 3),
(15, 'DIFFERENT', 0, 4);

-- -----------------------------------------------------------
-- SAMPLE QUESTIONS — ColdBox (category_id = 2)
-- -----------------------------------------------------------
INSERT INTO `questions` (`category_id`, `difficulty_id`, `question_text`, `code_snippet`, `explanation`, `created_by`) VALUES
(2, 1, 'What design pattern does ColdBox follow?', NULL,
 'ColdBox follows the Model-View-Controller (MVC) design pattern, separating concerns into handlers (controllers), models (services/entities), and views.', 1),

(2, 2, 'What is WireBox in ColdBox?', NULL,
 'WireBox is ColdBox''s built-in Dependency Injection (DI) and Aspect-Oriented Programming (AOP) framework. It manages object creation and dependency resolution.', 1),

(2, 2, 'What is the purpose of prc (Private Request Collection) in ColdBox?',
 'function index(event, rc, prc) {\n  prc.data = myService.getData();\n  event.setView("main/index");\n}',
 'prc (Private Request Collection) is used to pass data from handlers to views that should NOT be accessible via URL parameters, unlike rc (Request Collection).', 1),

(2, 3, 'How do ColdBox interceptors work?', NULL,
 'Interceptors are event-driven components that listen to specific interception points in the ColdBox request lifecycle. They can execute code before/after events like preProcess, postProcess, preEvent, etc.', 1),

(2, 1, 'Which folder contains ColdBox handlers by convention?', NULL,
 'By ColdBox convention, handlers (controllers) are placed in the /handlers directory and are automatically mapped by the framework.', 1);

-- Options for ColdBox Q1 (id=16)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(16, 'Singleton', 0, 1),
(16, 'MVC (Model-View-Controller)', 1, 2),
(16, 'Observer', 0, 3),
(16, 'Factory', 0, 4);

-- Options for ColdBox Q2 (id=17)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(17, 'A templating engine', 0, 1),
(17, 'A Dependency Injection framework', 1, 2),
(17, 'A CSS framework', 0, 3),
(17, 'A database ORM', 0, 4);

-- Options for ColdBox Q3 (id=18)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(18, 'It stores URL parameters', 0, 1),
(18, 'It passes private data from handlers to views', 1, 2),
(18, 'It stores session data', 0, 3),
(18, 'It manages form submissions', 0, 4);

-- Options for ColdBox Q4 (id=19)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(19, 'They are scheduled tasks', 0, 1),
(19, 'They listen to lifecycle interception points', 1, 2),
(19, 'They validate form input', 0, 3),
(19, 'They route URLs', 0, 4);

-- Options for ColdBox Q5 (id=20)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(20, '/controllers', 0, 1),
(20, '/handlers', 1, 2),
(20, '/actions', 0, 3),
(20, '/routes', 0, 4);

-- -----------------------------------------------------------
-- SAMPLE QUESTIONS — HTML & CSS (category_id = 5)
-- -----------------------------------------------------------
INSERT INTO `questions` (`category_id`, `difficulty_id`, `question_text`, `code_snippet`, `explanation`, `created_by`) VALUES
(5, 1, 'What does the <meta viewport> tag do?',
 '<meta name="viewport" content="width=device-width, initial-scale=1">',
 'The viewport meta tag controls how a page is displayed on mobile devices, setting the width to the device width and initial zoom level.', 1),

(5, 2, 'What is the difference between Flexbox and Grid?', NULL,
 'Flexbox is one-dimensional (row or column), while CSS Grid is two-dimensional (rows and columns simultaneously). Flexbox is best for components, Grid for full layouts.', 1),

(5, 1, 'Which CSS property is used to make an element invisible but still take up space?', NULL,
 'visibility: hidden makes an element invisible while preserving its space in the layout, unlike display: none which removes it entirely.', 1);

-- Options for HTML Q1 (id=21)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(21, 'Sets the page title', 0, 1),
(21, 'Controls mobile display and zoom', 1, 2),
(21, 'Defines character encoding', 0, 3),
(21, 'Links an external stylesheet', 0, 4);

-- Options for HTML Q2 (id=22)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(22, 'They are identical', 0, 1),
(22, 'Flexbox is 1D, Grid is 2D', 1, 2),
(22, 'Grid is older than Flexbox', 0, 3),
(22, 'Flexbox is for images only', 0, 4);

-- Options for HTML Q3 (id=23)
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `sort_order`) VALUES
(23, 'display: none', 0, 1),
(23, 'opacity: 0', 0, 2),
(23, 'visibility: hidden', 1, 3),
(23, 'position: absolute', 0, 4);

-- -----------------------------------------------------------
-- SAMPLE TESTS
-- -----------------------------------------------------------
INSERT INTO `tests` (`title`, `description`, `category_id`, `difficulty_id`, `total_questions`, `duration_minutes`, `negative_marking`, `negative_mark_value`, `pass_percentage`, `is_practice`, `created_by`) VALUES
('ColdFusion Basics',       'Test your fundamental ColdFusion/CFML knowledge',                1, 1, 5,  10, 0, 0.00, 40, 0, 1),
('JavaScript Essentials',   'Core JavaScript concepts — closures, types, event loop',         4, 2, 5,  10, 1, 0.25, 40, 0, 1),
('MySQL Fundamentals',      'SQL queries, joins, indexes, and optimization',                  3, 1, 5,  10, 0, 0.00, 40, 0, 1),
('ColdBox Framework',       'ColdBox MVC — handlers, WireBox, interceptors, conventions',     2, 2, 5,  15, 1, 0.25, 40, 0, 1),
('HTML & CSS Mastery',      'Semantic HTML5, CSS3, responsive design',                        5, 1, 3,   8, 0, 0.00, 40, 0, 1),
('Mixed Practice',          'Practice questions from all categories',                       NULL, NULL, 10, 20, 0, 0.00, 40, 1, 1);

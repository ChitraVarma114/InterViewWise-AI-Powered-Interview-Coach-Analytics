-- Insert sample users
INSERT INTO users (username, email, password, role, education_level, linkedin_profile, registered_at)
VALUES
('john_doe', 'john@example.com', '$2b$12$7cXoYBqBzEFAiJEMDqvGmOkmZ57h4A9N4SlWZCxnOCn.Dh4MkBhVq', 'Software Developer', 'B.Tech', 'https://linkedin.com/in/johndoe', NOW()),
('jane_smith', 'jane@example.com', '$2b$12$7cXoYBqBzEFAiJEMDqvGmOkmZ57h4A9N4SlWZCxnOCn.Dh4MkBhVq', 'Data Analyst', 'M.Sc', 'https://linkedin.com/in/janesmith', NOW());

-- Note: password here is "password123" hashed with bcrypt (Werkzeug)

-- Insert sample quizzes for Software Developer
INSERT INTO quizzes (role, question, option_a, option_b, option_c, option_d, correct_option)
VALUES
('Software Developer', 'What is the time complexity of binary search?', 'O(n)', 'O(log n)', 'O(n log n)', 'O(1)', 'B'),
('Software Developer', 'Which keyword is used to inherit a class in Python?', 'inherits', 'super', 'class', 'None of the above', 'D'),
('Software Developer', 'Which of the following is NOT a programming language?', 'Python', 'HTML', 'Java', 'C++', 'B');

-- Insert sample quizzes for Data Analyst
INSERT INTO quizzes (role, question, option_a, option_b, option_c, option_d, correct_option)
VALUES
('Data Analyst', 'Which library is commonly used in Python for data analysis?', 'NumPy', 'Matplotlib', 'Pandas', 'All of the above', 'D'),
('Data Analyst', 'Which SQL command is used to remove all records from a table without removing the table structure?', 'DELETE', 'TRUNCATE', 'DROP', 'CLEAR', 'B'),
('Data Analyst', 'In statistics, what does IQR stand for?', 'Inter Quartile Range', 'Internal Quality Ratio', 'International Query Rule', 'Independent Quantile Regression', 'A');

-- Insert sample interview questions for Software Developer
INSERT INTO interview_questions (role, question)
VALUES
('Software Developer', 'Explain the concept of polymorphism in object-oriented programming.'),
('Software Developer', 'What is the difference between an abstract class and an interface?'),
('Software Developer', 'Describe the MVC architecture pattern.');

-- Insert sample interview questions for Data Analyst
INSERT INTO interview_questions (role, question)
VALUES
('Data Analyst', 'Explain the difference between INNER JOIN and LEFT JOIN in SQL.'),
('Data Analyst', 'What is the difference between supervised and unsupervised learning?'),
('Data Analyst', 'Describe the steps you take to clean a dataset.');

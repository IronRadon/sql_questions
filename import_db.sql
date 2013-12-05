CREATE TABLE users(
	id INTEGER PRIMARY KEY,
	fname VARCHAR(255) NOT NULL,
	lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions(
	id INTEGER PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	body VARCHAR NOT NULL,
	author_id INTEGER NOT NULL,
	FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_followers(
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	follower_id INTEGER NOT NULL
);

CREATE TABLE replies(
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	parent_id INTEGER,
	author_id INTEGER NOT NULL,
	body VARCHAR NOT NULL
);

CREATE TABLE question_likes(
	id INTEGER PRIMARY KEY,
	question_id INTEGER NOT NULL,
	user_id INTEGER NOT NULL
);

INSERT INTO
	users (fname, lname)
VALUES
('John', 'Smith'), ('Pocahontas', 'Smith'), ('Jack', 'Noble'), ('Fern', 'Wood');

INSERT INTO
	questions (title, body, author_id)
VALUES
('Party', 'Why was I not invited? You know I love charades.',
	(SELECT id FROM users WHERE fname = 'Pocahontas')),
('Chores', 'Why doesnt Jack ever have to do any?',
	(SELECT id FROM users WHERE fname = 'Pocahontas')),
('SQL', 'How do I do a cartesian join?',
	(SELECT id FROM users WHERE fname = 'John'));

INSERT INTO
	question_followers (question_id, follower_id)
VALUES
	((SELECT id FROM questions WHERE title = 'Party'),
		(SELECT id FROM users WHERE fname = 'Pocahontas')),
	((SELECT id FROM questions WHERE title = 'SQL'),
		(SELECT id FROM users WHERE fname = 'Jack')),
	((SELECT id FROM questions WHERE title = 'Chores'),
		(SELECT id FROM users WHERE fname = 'Fern'));

INSERT INTO
	replies (question_id, parent_id, author_id, body)
VALUES
((SELECT id FROM questions WHERE title = 'Party'), NULL,
		(SELECT id FROM users WHERE fname = 'Jack'),
		'You got embarrassingly drunk at the last party. :\'),
((SELECT id FROM questions WHERE title = 'Party'), 1,
	(SELECT id FROM users WHERE fname = 'Pocahontas'),
	'I dont remember that at all!'),
((SELECT id FROM questions WHERE title = 'Chores'), NULL,
		(SELECT id FROM users WHERE fname = 'Fern'),
		'Jack does too do chores. He does secret chores. Leave him ALONE!!!');

INSERT INTO
	question_likes (question_id, user_id)
VALUES
	((SELECT id FROM questions WHERE title = 'Party'), (SELECT id FROM users WHERE fname = 'Jack')),
	((SELECT id FROM questions WHERE title = 'Party'), (SELECT id FROM users WHERE fname = 'Fern')),
	((SELECT id FROM questions WHERE title = 'Party'), (SELECT id FROM users WHERE fname = 'John'));




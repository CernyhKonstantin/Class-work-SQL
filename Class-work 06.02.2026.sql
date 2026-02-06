--create database
CREATE DATABASE pv521;

GO
--use database
USE pv521;

GO
--drop tables if they exist
DROP TABLE books;
DROP TABLE authors;
DROP TABLE genres;

GO
--create table Authors
CREATE TABLE authors(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(30) NOT NULL,
    surname NVARCHAR(30) NOT NULL
);

GO
--create table Genres
CREATE TABLE genres(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(30) NOT NULL UNIQUE
);

GO
--create table Books
CREATE TABLE books(
    id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(30) NOT NULL,
    [year] INT NOT NULL CHECK ([year] >= 1800 AND [year] <= YEAR(GETDATE())),
    author_id INT NOT NULL,
    genre_id INT NOT NULL,
    CONSTRAINT FK_books_authors FOREIGN KEY (author_id) REFERENCES authors(id),
    CONSTRAINT FK_books_genres FOREIGN KEY (genre_id) REFERENCES genres(id)
);

GO
--insert data into Authors
INSERT INTO authors (name, surname)
VALUES
    ('Taras', 'Shevchenko'),
    ('Ivan', 'Franko'),
    ('Lesya', 'Ukrainka'),
    ('Mykhailo', 'Kotsiubynskyi');

GO
--insert data into Genres
INSERT INTO genres (name)
VALUES
    ('Poetry'),
    ('Novel'),
    ('Drama');

GO
--insert data into Books
INSERT INTO books (title, [year], author_id, genre_id)
VALUES
    ('Kobzar', 1840, 1, 1),
    ('Haidamaky', 1841, 1, 1),
    ('Zakhar Berkut', 1883, 2, 2),
    ('Moses', 1905, 2, 3),
    ('Forest Song', 1911, 3, 3),
    ('Intermezzo', 1908, 4, 2);

GO
--example run: select book, author, genre
SELECT
    b.title AS Book,
    a.name + ' ' + a.surname AS Author,
    g.name AS Genre
FROM books b
JOIN authors a ON b.author_id = a.id
JOIN genres g ON b.genre_id = g.id;

GO

IF DB_ID('LibraryDB') IS NOT NULL
    DROP DATABASE LibraryDB;
GO

CREATE DATABASE LibraryDB;
GO

USE LibraryDB;
GO

-- Authors table
CREATE TABLE Authors
(
    Id INT IDENTITY PRIMARY KEY,
    Surname NVARCHAR(50) NOT NULL
);

-- Genres table
CREATE TABLE Genres
(
    Id INT IDENTITY PRIMARY KEY,
    GenreName NVARCHAR(50) NOT NULL
);

-- Books table
CREATE TABLE Books
(
    Id INT IDENTITY PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Id_Author INT,
    Id_Genre INT,
    FOREIGN KEY (Id_Author) REFERENCES Authors(Id),
    FOREIGN KEY (Id_Genre) REFERENCES Genres(Id)
);

-- Authors
INSERT INTO Authors (Surname)
VALUES
('King'),
('Rowling'),
('Tolkien'),
('Brown');

-- Genres
INSERT INTO Genres (GenreName)
VALUES
('Horror'),
('Fantasy'),
('Detective'),
('Science Fiction');

-- Books
INSERT INTO Books (Title, Price, Id_Author, Id_Genre)
VALUES
('The Shining', 15.00, 1, 1),
('Harry Potter', 20.00, 2, 2),
('The Hobbit', 18.00, 3, 2),
('Da Vinci Code', 14.00, 4, 3),
('IT', 10.00, 1, 1),
('Angels and Demons', 17.00, 4, 3),
('Dune', 25.00, 1, 4);

CREATE VIEW Books_Authors_View
AS
SELECT 
    b.Id,
    b.Title,
    b.Price,
    a.Surname
FROM Books b
INNER JOIN Authors a
    ON b.Id_Author = a.Id;
GO

SELECT Title 
FROM Books_Authors_View
WHERE Price > 16;
GO

CREATE VIEW Books_Genres_View
AS
SELECT
    b.Id,
    b.Title,
    b.Price,
    g.GenreName
FROM Books b
INNER JOIN Genres g
    ON b.Id_Genre = g.Id;
GO

SELECT
    Title,
    Price,
    GenreName
FROM Books_Genres_View
WHERE Price > 12
AND GenreName <> 'Fantasy';
GO

CREATE PROCEDURE getBookById @id INT
AS
BEGIN
SELECT * FROM books WHERE id=@id 
END
GO

EXEC getBookById @id=3
GO

CREATE TABLE authors_logs
(
  id INT PRIMARY KEY IDENTITY(1,1),
  id_author INT FOREIGN KEY REFERENCES authors(id),
  content NVARCHAR(100) NOT NULL
)
GO

CREATE TRIGGER authorLogTrigger
ON authors
AFTER INSERT
AS
BEGIN
    INSERT INTO authors_logs (id_author, content)
    SELECT INSERTED.id, 'New author added with ID: ' + CONVERT(NVARCHAR(10), INSERTED.id)
    FROM INSERTED;
END;
GO

SELECT * FROM authors_logs;

INSERT INTO Authors (Surname)
VALUES ('Test Author');
GO

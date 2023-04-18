use master
Go
IF DB_ID('BiblioteksDatabase') IS NOT NULL -- Drops the database if it exists
	begin
		ALTER DATABASE BiblioteksDatabase SET SINGLE_USER WITH ROLLBACK IMMEDIATE
		DROP DATABASE BiblioteksDatabase
	END

CREATE DATABASE BiblioteksDatabase -- Creates the Database

USE BiblioteksDatabase -- Uses the Database
GO
-- Tables are being created below
CREATE TABLE Authors (
AuthorId int IDENTITY(1,1) primary key NOT NULL, -- Identity increments the id automatically.
AuthorName nvarchar(max),
AuthorAddress nvarchar(max),
AuthorPhone nvarchar(max)
);

CREATE TABLE Books (
BookId int identity(1,1) primary key not null,
BookTitle nvarchar(max),
AuthorName nvarchar(max),
AuthorId int,
	FOREIGN KEY (AuthorId) references Authors(AuthorId)--Connects to the Primary key
);

CREATE TABLE Borrowers (
BorrowerId int identity(1,1) primary key not null,
BorrowerName nvarchar(max),
BookId int,
	FOREIGN KEY (BookId) references Books(BookId), --Connects to the Primary key
BorrowDate date
);

INSERT INTO Authors (AuthorName)
VALUES
('Ada Lovelace'),
('Elon Musk'),
('Cristiano Ronaldo'),
('J.K Rowling'),
('Steve')

INSERT INTO Authors (AuthorAddress)
VALUES 
('Church of St Mary Magdalene, Hucknall'),
('Homeless'),
('Saudi Arabian Palace'),
('Morningside Road Edinburgh EH10 4BF'),
('Area 51')

INSERT INTO Authors (AuthorPhone)
VALUES 
('44 7911 241561'),
('+1 202-918-2132'),
('+966 57 127 0004'),
('+44 7419 964392'),
('Unknown')

INSERT INTO BOOKS (BookTitle, AuthorId)
VALUES
('Changing the World',1),
('They forced me to buy Twitter',2),
('Cristiano Ronaldo', 3),
('Harry Potter and the Philiospher Stone',4),
('The Government can kiss my A**',5)

INSERT INTO Borrowers(BorrowerName,BookId, BorrowDate)
VALUES
('Anders Andersen', 1, '2022-12-11'),
('Benny Bennyson', 2, '2022-12-11'),
('Klo Klogesen', 3,' 2022-12-11'),
('Fedtmule', 4, '2022-12-11'),
('Asger Hilde', 5, '2022-12-11')

-- Many statements to display all books connected to an author, how many books they have written with titles.
SELECT COUNT(BOOKS.BookId) AS AmountOfBooks,Authors.AuthorName as Author, STRING_AGG(BOOKS.BookTitle,', ') as title 
FROM Authors 
Join BOOKS on Authors.AuthorId = BOOKS.AuthorId
GROUP BY Authors.AuthorName

-- Displays The book titles which the borrowers have borrowed
Select Borrowers.BorrowerName as Borrower, BOOKS.BookTitle
From Borrowers
join BOOKS on Borrowers.BookId = BOOKS.BookId

-- This stored procedure will retrieve the book information, where you can replace J.K. Rowling with any author name to retrieve the book information for that author.
USE BiblioteksDatabase
GO
CREATE PROCEDURE GetBookInfoByAuthorName
	@AuthorName nvarchar(max)
AS
BEGIN
	SELECT COUNT(BOOKS.BookId) AS AmountOfBooks, Authors.AuthorName as Author, STRING_AGG(BOOKS.BookTitle,', ') as Title
	FROM Authors
	JOIN BOOKS ON Authors.AuthorId = BOOKS.AuthorId
	WHERE Authors.AuthorName = @AuthorName
	GROUP BY Authors.AuthorName
	END
EXEC GetBookInfoByAuthorName 'J.K Rowling'
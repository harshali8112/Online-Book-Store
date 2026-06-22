--Create Database
CREATE DATABASE OnlineBooksore;

--Switch to the database
\c OnlineBookstore;

--Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books(
     Book_ID SERIAL PRIMARY KEY,
	 Title VARCHAR(100),
	 Author VARCHAR(100),
	 Genre VARCHAR(50),
	 Published_Year INT,
	 Price NUMERIC(10,2),
	 Stock INT
);

DROP TABLE IF EXISTS customers;
CREATE TABLE Customers(
     Customer_ID SERIAL PRIMARY KEY,
	 Name VARCHAR (100),
	 Email VARCHAR(100),
	 Phone VARCHAR(15),
	 City VARCHAR(50),
	 Country VARCHAR(150)
);

DROP TABLE IF EXISTS orders
CREATE TABLE Orders(
     Order_ID SERIAL PRIMARY KEY,
	 Customer_ID INT REFERENCES Customers(Customer_ID),
	 Book_ID INT REFERENCES Books(Book_ID),
	 Order_Date DATE,
	 Quantity INT,
	 Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

SHOW data_directory;

--Import data into Books Table
COPY Books
FROM 'C:\Program Files\PostgreSQL\17\data\base\Books.csv'
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '\'
);

--Import  data into Customers Table
COPY Customers
FROM 'C:\Program Files\PostgreSQL\17\data\base\Customers.csv'
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '\'
);

--Import data into Orders Table
COPY Orders
FROM 'C:\Program Files\PostgreSQL\17\data\base\Orders.csv'
WITH (
    FORMAT CSV,
    HEADER true,
    DELIMITER ',',
    QUOTE '"',
    ESCAPE '\'
);

--1)Retrieve all books in the 'Fiction' genre

SELECT * From Books  
WHERE Genre='Fiction';

--2)Find Books published after the year 1950

SELECT * FROM Books
WHERE Published_Year > 1950;

--3)List all the customers from Canada

SELECT * FROM Customers
WHERE Country='Canada';

--4)Show orders placed in November 2023

SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

--5)Retrieve total stock of books available

SELECT SUM(Stock) AS total_stock
FROM Books

--6)Find details of the most expensive book

SELECT * FROM Books
ORDER BY Price DESC
LIMIT 1;

--7)Show all customers who ordered more than 1 quantity of a book

SELECT * FROM Orders
WHERE Quantity>1

--8)Retrieve all orders where total amount exceeds $20

SELECT * FROM Orders
WHERE Total_Amount>20

--9)List all genres available in the books table

SELECT DISTINCT Genre From Books

--10)Find the books with the lowest stock

SELECT * FROM Books
ORDER BY Stock ASC
LIMIT 1

--11)Calculate the total revenue generated from all orders

SELECT SUM(Total_Amount) AS total_revenue
FROM Orders

--Advance Questions
--1)Retrieve the total number of books sold for each genre

SELECT b.Genre,SUM(o.Quantity) AS total_Books_sold
From Orders o
JOIN Books b ON o.Book_ID=b.Book_ID
GROUP BY b.Genre;

--2)Find the average price of books in the Fantasy genre

SELECT AVG(Price) AS avg_price
FROM Books
WHERE Genre='Fantasy'

--3)List customers who have placed atleast 2 orders

SELECT o.Customer_ID,c.Name,COUNT(o.Order_ID) AS order_count
FROM Orders o
JOIN Customers c ON o.Customer_ID=c.Customer_ID
GROUP BY o.Customer_ID,c.Name
HAVING COUNT(Order_ID)>=2

--4)Find the most frequently ordered book

SELECT o.Book_ID,b.Title,COUNT(o.Order_ID)AS order_count
FROM Orders o
JOIN Books b ON o.Book_ID=b.Book_ID
GROUP BY o.Book_ID,b.Title
ORDER BY order_count DESC
LIMIT 1

--5)Show the top 3 most expensive books of Fantasy Genre

SELECT * FROM Books
WHERE Genre='Fantasy'
ORDER BY Price DESC
LIMIT 3

--6)Retrive the total quantity of books sold by each author

SELECT b.Author ,SUM(o.Quantity) AS total_Books_Sold
From Orders o
JOIN Books b ON o.Book_ID=b.Book_ID
GROUP BY b.Author

--7)List the cities where customers who spent over $30 are located

SELECT DISTINCT(c.City),Total_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID=c.Customer_ID
WHERE o.Total_Amount>30

--8)Find the customer who spent the most on orders

SELECT c.Customer_ID,c.Name,SUM(o.Total_Amount) AS total_spent
FROM Orders o
JOIN Customers c ON o.Customer_ID=c.Customer_ID
GROUP BY c.Customer_ID,c.Name
ORDER BY total_spent DESC 
LIMIT 1

--9)Calculate the stock remaining after fulfilling all orders

SELECT b.Book_ID,b.Title,b.Stock,COALESCE(SUM(o.Quantity),0) AS order_quantity,
       b.Stock-COALESCE(SUM(o.Quantity),0) AS remaining_quantity
FROM Books b
LEFT JOIN Orders o ON b.Book_ID=o.Book_ID
GROUP BY b.Book_ID ORDER BY b.Book_ID


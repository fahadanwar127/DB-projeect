
CREATE DATABASE movie_ticket_reservation_db;
USE movie_ticket_reservation_db;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Faiza1234567@';
FLUSH PRIVILEGES;
-- DROP TABLES if they exist
DROP TABLE IF EXISTS Ticket;
DROP TABLE IF EXISTS Reservation;
DROP TABLE IF EXISTS Customer;
DROP TABLE IF EXISTS Movie;

-- DDL: Create Tables

CREATE TABLE Movie (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    director VARCHAR(100),
    genre VARCHAR(50),
    release_date DATE
);

CREATE TABLE Customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15)
);

CREATE TABLE Reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    reservation_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id)
);

CREATE TABLE Ticket (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    movie_id INT,
    ticket_price DECIMAL(10, 2) NOT NULL,
    seat_number VARCHAR(10),
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id),
    FOREIGN KEY (movie_id) REFERENCES Movie(movie_id)
);

-- DML: Insert sample data

INSERT INTO Movie (title, director, genre, release_date) VALUES
  ('The Shawshank Redemption', 'Frank Darabont', 'Drama', '1994-09-22'),
  ('The Dark Knight', 'Christopher Nolan', 'Action', '2008-07-18'),
  ('Inception', 'Christopher Nolan', 'Sci-Fi', '2010-07-16');

INSERT INTO Customer (name, email, phone) VALUES
  ('John Doe', 'john.doe@example.com', '123-456-7890'),
  ('Jane Smith', 'jane.smith@example.com', '987-654-3210');

INSERT INTO Reservation (customer_id) VALUES (1);

INSERT INTO Ticket (reservation_id, movie_id, ticket_price, seat_number) VALUES
  (1, 1, 12.50, 'A1'),
  (1, 2, 15.00, 'A2');

-- DML: Example UPDATE and DELETE
UPDATE Customer SET phone = '555-123-4567' WHERE customer_id = 1;
DELETE FROM Ticket WHERE ticket_id = 2;

-- VIEW with Joins
CREATE OR REPLACE VIEW ReservationDetails AS
SELECT 
    r.reservation_id,
    c.name AS customer_name,
    m.title AS movie_title,
    t.seat_number,
    t.ticket_price
FROM Reservation r
JOIN Customer c ON r.customer_id = c.customer_id
JOIN Ticket t ON r.reservation_id = t.reservation_id
JOIN Movie m ON t.movie_id = m.movie_id;

-- STORED PROCEDURE with input parameters
DELIMITER //
CREATE PROCEDURE GetMovieTicketsByCustomer(IN customerEmail VARCHAR(150))
BEGIN
    SELECT c.name, m.title, t.seat_number, t.ticket_price
    FROM Customer c
    JOIN Reservation r ON c.customer_id = r.customer_id
    JOIN Ticket t ON r.reservation_id = t.reservation_id
    JOIN Movie m ON t.movie_id = m.movie_id
    WHERE c.email = customerEmail;
END;
//
DELIMITER ;

-- SCALAR FUNCTION
DELIMITER //
CREATE FUNCTION GetTicketTotalPrice(ticketID INT) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    SELECT ticket_price INTO total FROM Ticket WHERE ticket_id = ticketID;
    RETURN total;
END;
//
DELIMITER ;

-- INLINE TABLE-VALUED FUNCTION (MySQL uses VIEWs to simulate this)
CREATE OR REPLACE VIEW TicketsByGenre AS
SELECT 
    m.genre,
    COUNT(t.ticket_id) AS total_tickets
FROM Movie m
JOIN Ticket t ON m.movie_id = t.movie_id
GROUP BY m.genre;

-- TRIGGERS
DELIMITER //
CREATE TRIGGER before_customer_insert
BEFORE INSERT ON Customer
FOR EACH ROW
BEGIN
    IF NEW.email IS NULL OR NEW.name IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Email and Name are required!';
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER after_ticket_insert
AFTER INSERT ON Ticket
FOR EACH ROW
BEGIN
    INSERT INTO Reservation (customer_id)
    SELECT customer_id FROM Reservation WHERE reservation_id = NEW.reservation_id;
END;
//
DELIMITER ;

-- TRANSACTION MANAGEMENT (manual example)
START TRANSACTION;
    INSERT INTO Customer (name, email, phone) VALUES ('Alice Cooper', 'alice@example.com', '555-000-1111');
    INSERT INTO Reservation (customer_id) VALUES (LAST_INSERT_ID());
    -- Intentional error to test ROLLBACK:
    -- INSERT INTO Ticket (reservation_id, movie_id, ticket_price, seat_number) VALUES (9999, 1, 10.00, 'B1');
COMMIT;

-- COMPLEX SELECT QUERY
SELECT 
    m.genre,
    COUNT(t.ticket_id) AS ticket_count,
    AVG(t.ticket_price) AS average_price
FROM Movie m
JOIN Ticket t ON m.movie_id = t.movie_id
GROUP BY m.genre
HAVING COUNT(t.ticket_id) > 0
ORDER BY average_price DESC;


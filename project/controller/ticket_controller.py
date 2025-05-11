from models.db import Database

class TicketController:
    def __init__(self):
        self.db = Database()

    def list_movies(self):
        query = "SELECT * FROM Movie;"
        return self.db.execute(query, fetch=True)

    def get_customer_reservations(self, customer_id):
        query = """
        SELECT r.reservation_id, r.reservation_date, t.ticket_id, t.seat_number, t.ticket_price, m.title AS movie_title
        FROM Reservation r
        JOIN Ticket t ON r.reservation_id = t.reservation_id
        JOIN Movie m ON t.movie_id = m.movie_id
        WHERE r.customer_id = %s;
        """
        return self.db.execute(query, (customer_id,), fetch=True)

    def reserve_ticket(self, customer_id, movie_id, seat_number, ticket_price):
        query = "INSERT INTO Reservation (customer_id) VALUES (%s);"
        self.db.execute(query, (customer_id,))
        reservation_id = self.db.cursor.lastrowid
        
        query = "INSERT INTO Ticket (reservation_id, movie_id, ticket_price, seat_number) VALUES (%s, %s, %s, %s);"
        self.db.execute(query, (reservation_id, movie_id, ticket_price, seat_number))
        
        return f"Reservation successful! Reservation ID: {reservation_id}"

    def close(self):
        self.db.close()


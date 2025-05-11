class TicketView:
    @staticmethod
    def show_menu():
        print("--- Movie Ticket Reservation System ---")
        print("1. List Movies")
        print("2. Reserve Ticket")
        print("3. View My Reservations")
        print("0. Exit")

    @staticmethod
    def get_input(prompt):
        return input(f"{prompt}: ")

    @staticmethod
    def display_movies(movies):
        if movies:
            for movie in movies:
                print(f"{movie['movie_id']}. {movie['title']} - {movie['genre']} ({movie['release_date']})")
        else:
            print("No movies available.")

    @staticmethod
    def display_reservations(reservations):
        if reservations:
            for res in reservations:
                print(f"Reservation ID: {res['reservation_id']}, Movie: {res['movie_title']}, Seat: {res['seat_number']}, Price: ${res['ticket_price']}")
        else:
            print("No reservations found.")


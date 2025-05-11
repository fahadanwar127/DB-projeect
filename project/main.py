from controllers.ticket_controller import TicketController
from views.ticket_view import TicketView

if __name__ == '__main__':
    controller = TicketController()
    view = TicketView()

    while True:
        view.show_menu()
        choice = view.get_input('Select an option')
        
        if choice == '1':
            movies = controller.list_movies()
            view.display_movies(movies)
        elif choice == '2':
            customer_id = int(view.get_input('Enter your customer ID'))
            movie_id = int(view.get_input('Select movie ID'))
            seat_number = view.get_input('Enter seat number')
            ticket_price = float(view.get_input('Enter ticket price'))
            print(controller.reserve_ticket(customer_id, movie_id, seat_number, ticket_price))
        elif choice == '3':
            customer_id = int(view.get_input('Enter your customer ID'))
            reservations = controller.get_customer_reservations(customer_id)
            view.display_reservations(reservations)
        elif choice == '0':
            break
        else:
            print("Invalid choice. Please try again.")

    controller.close()

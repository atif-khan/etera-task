import Foundation

protocol RestaurantServiceProtocol {
    func loadInitialRestaurants() -> [Restaurant]
}

/// Mock service that returns static sample data.
struct RestaurantService: RestaurantServiceProtocol {
    func loadInitialRestaurants() -> [Restaurant] {
        //TODO: Fetch Actual Restuarants from API/Memory
        //Currently creating dummy restaurants
        Restaurant.sample()
    }
}



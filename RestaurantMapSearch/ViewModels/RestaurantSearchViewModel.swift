import Foundation


final class RestaurantSearchViewModel {
    private let service: RestaurantServiceProtocol
    
    struct State {
        var query: String
        var locationLabel: String
        var restaurants: [Restaurant]
        var selectedID: UUID?
        var ratingFilter: Double?
        
        var title: String {
            return "Over \(restaurants.count) restaurants"
        }
        
        /// The restaurant currently selected by the user, if any.
        var selectedRestaurant: Restaurant? {
            guard let id = selectedID else { return nil }
            return restaurants.first(where: { $0.id == id })
        }
        
    }
    
    private(set) var state: State {
        didSet { onChange?(state) }
    }
    
    var onChange: ((State) -> Void)?
    
    init(service: RestaurantServiceProtocol = RestaurantService()) {
        self.service = service
        let restaurants = service.loadInitialRestaurants()
        self.state = State(
            //TODO: DI query and locationLabel
            query: "Indian restaurants",
            locationLabel: "London - United Kingdom",
            restaurants: restaurants,
            selectedID: nil,
            ratingFilter: 4.0
        )
    }
    
    func selectRestaurant(id: UUID?) {
        state.selectedID = id
    }
    
    //TODO: Apply all the filters here and udpate the status
    
    func setRatingFilter(_ minRating: Double?) {
        state.ratingFilter = minRating
    }
    
    /// Returns the restaurant with the given identifier, if present in the current state.
    func restaurant(with id: UUID) -> Restaurant? {
        state.restaurants.first(where: { $0.id == id })
    }
}

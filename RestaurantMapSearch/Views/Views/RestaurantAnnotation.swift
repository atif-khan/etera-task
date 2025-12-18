import MapKit

final class RestaurantAnnotation: NSObject, MKAnnotation {
    let restaurant: Restaurant
    var coordinate: CLLocationCoordinate2D { restaurant.coordinate }
    var title: String? { restaurant.name }
    
    init(restaurant: Restaurant) {
        self.restaurant = restaurant
        super.init()
    }
}

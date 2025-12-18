import Foundation
import CoreLocation

struct Restaurant: Identifiable {
    
    let id: UUID
    var name: String
    var rating: Double
    var category: String
    var area: String
    var isOpenNow: Bool
    var closesAt: String
    var distanceMeters: Int
    var coordinate: CLLocationCoordinate2D
    var heroImageURLs: [URL]
    var reveiw: String
    var reviewerURL:URL
    
    static func sample() -> [Restaurant] {
        // NOTE: Placeholder data to demonstrate UI state changes.
        // Replace with API layer + pagination + caching.
        func url(_ s: String) -> URL { URL(string: s)! }
        return [
            Restaurant(
                id: UUID(),
                name: "Entrecôte Café de Paris - The Dubai Mall",
                rating: 4.8,
                category: "African restaurant",
                area: "Jumeirah",
                isOpenNow: true,
                closesAt: "3AM",
                distanceMeters: 300,
                coordinate: .init(latitude: 25.1972, longitude: 55.2744),
                heroImageURLs: [
                    url("https://picsum.photos/seed/entrecote1/400/400"),
                    url("https://picsum.photos/seed/entrecote2/400/400"),
                    url("https://picsum.photos/seed/entrecote3/400/400"),
                    url("https://picsum.photos/seed/entrecote4/400/400"),
                    url("https://picsum.photos/seed/entrecote5/400/400")
                ],
                reveiw: "\"The food and the ambience was amazing 1\"",
                reviewerURL: url("https://picsum.photos/seed/entrecote6/24/24")
                
            ),
            Restaurant(
                id: UUID(),
                name: "Akira Back Dubai",
                rating: 4.7,
                category: "Japanese restaurant",
                area: "Jumeirah",
                isOpenNow: true,
                closesAt: "3AM",
                distanceMeters: 300,
                coordinate: .init(latitude: 25.2010, longitude: 55.2712),
                heroImageURLs: [
                    url("https://picsum.photos/seed/akira1/400/400"),
                    url("https://picsum.photos/seed/akira2/400/400"),
                    url("https://picsum.photos/seed/akira3/400/400"),
                    url("https://picsum.photos/seed/akira4/400/400"),
                    url("https://picsum.photos/seed/akira5/400/400")
                ],
                reveiw: "\"The food and the ambience was amazing 2\"",
                reviewerURL: url("https://picsum.photos/seed/akira6/24/24")
            )
        ]
    }
}

import MapKit

final class RestaurantAnnotationView: MKAnnotationView {
    static let reuseID = "RestaurantAnnotationView"
    
    private let imageView = UIImageView()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        backgroundColor = .clear
        
        imageView.frame = bounds
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = bounds.width / 2
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = AppColors.annotationBorder.cgColor
        imageView.clipsToBounds = true
        
        addSubview(imageView)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    func configure(with restaurant: Restaurant) {
        // NOTE: In a real app, use an image pipeline (Nuke/Kingfisher) + prefetching.
        // Here we load the first hero image just to demonstrate avatar-style pins.
        if let url = restaurant.heroImageURLs.first {
            ImageLoader.shared.load(url) { [weak self] img in
                self?.imageView.image = img
            }
        }
    }
}

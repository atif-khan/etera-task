import UIKit

final class RestaurantCardCell: UITableViewCell {
    static let reuseID = "RestaurantCardCell"
    
    private let container = UIView()
    private let nameLabel = UILabel()
    private let metaLabel = UILabel()
    private let statusLabel = UILabel()
    private let imagesCollection: UICollectionView
    private let reviewerImageView = UIImageView()
    private let reviewLabel = UILabel()
    private let primaryButton = UIButton(type: .system)
    private let secondaryButton = UIButton(type: .system)
    
    private var imageURLs: [URL] = []
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 8
        layout.itemSize = CGSize(width: 142, height: 134)
        imagesCollection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        reviewerImageView.clipsToBounds = true
        reviewerImageView.layer.cornerRadius = reviewerImageView.bounds.height / 2
        
        primaryButton.layer.cornerRadius = primaryButton.bounds.height / 2
        primaryButton.clipsToBounds = true
        
        secondaryButton.layer.cornerRadius = secondaryButton.bounds.height / 2
        secondaryButton.clipsToBounds = true
        
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = AppColors.background
        
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = AppColors.background
        container.layer.cornerRadius = 16
        
        nameLabel.font = .preferredFont(forTextStyle: .headline)
        nameLabel.numberOfLines = 2
        nameLabel.textColor = AppColors.primaryText
        
        metaLabel.font = .preferredFont(forTextStyle: .subheadline)
        metaLabel.textColor = AppColors.secondaryText
        
        statusLabel.font = .preferredFont(forTextStyle: .footnote)
        statusLabel.textColor = AppColors.secondaryText
        
        imagesCollection.backgroundColor = .clear
        imagesCollection.showsHorizontalScrollIndicator = false
        imagesCollection.dataSource = self
        imagesCollection.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseID)
        imagesCollection.heightAnchor.constraint(equalToConstant: 134).isActive = true
        
        reviewerImageView.image = UIImage(named: "profile")
        
        reviewLabel.font = .preferredFont(forTextStyle: .footnote)
        reviewLabel.textColor = AppColors.secondaryText
        reviewLabel.numberOfLines = 2
        
        let reviewStack = UIStackView(arrangedSubviews: [reviewerImageView, reviewLabel])
        reviewStack.axis = .horizontal
        reviewStack.spacing = 8
        
        
        var primaryButtonConfig = UIButton.Configuration.filled()
        var primaryTitle = AttributedString("Book now")
        primaryTitle.font = .systemFont(ofSize: 13, weight: .medium)
        primaryButtonConfig.attributedTitle = primaryTitle
        
        primaryButtonConfig.image = UIImage(named: "calendar")?.resized(to: CGSize(width: 16,
                                                                                   height: 16))
        primaryButtonConfig.baseBackgroundColor = AppColors.secondaryBackground
        primaryButtonConfig.baseForegroundColor = AppColors.primaryText
        primaryButtonConfig.imagePlacement = .leading
        primaryButtonConfig.imagePadding = 4
        primaryButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        primaryButton.configuration = primaryButtonConfig
        
        
        var secondaryButtonConfig = UIButton.Configuration.filled()
        var secondaryTitle = AttributedString("Menu")
        secondaryTitle.font = .systemFont(ofSize: 13, weight: .medium)
        secondaryButtonConfig.attributedTitle = secondaryTitle
        
        secondaryButtonConfig.image = UIImage(named: "menu")?.resized(to: CGSize(width: 16,
                                                                                 height: 16))
        secondaryButtonConfig.baseBackgroundColor = AppColors.secondaryBackground
        secondaryButtonConfig.baseForegroundColor = AppColors.primaryText
        secondaryButtonConfig.imagePlacement = .leading
        secondaryButtonConfig.imagePadding = 4
        secondaryButtonConfig.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        secondaryButton.configuration = secondaryButtonConfig
        
        let buttonsStack = UIStackView(arrangedSubviews: [primaryButton, secondaryButton])
        buttonsStack.axis = .horizontal
        buttonsStack.spacing = 8
        buttonsStack.distribution = .fill
        buttonsStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [nameLabel, metaLabel, statusLabel, imagesCollection, reviewStack, buttonsStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(stack)
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            primaryButton.heightAnchor.constraint(equalToConstant: 36),
            secondaryButton.heightAnchor.constraint(equalToConstant: 36),
            
            reviewerImageView.widthAnchor.constraint(equalToConstant: 24),
            reviewerImageView.heightAnchor.constraint(equalToConstant: 24),
            
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 24),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -24)
        ])
    }
    
    func configure(with restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        
        let metaText = "\(String(format: "%.2f", restaurant.rating)) ★  |  \(restaurant.category)  |  \(restaurant.area)"
        let metaAttributedText = NSMutableAttributedString(string: metaText)
        if let starRange = metaText.range(of: "★") {
            let nsRange = NSRange(starRange, in: metaText)
            metaAttributedText.addAttribute(
                .foregroundColor,
                value: AppColors.ratingStars,
                range: nsRange
            )
        }
        metaLabel.attributedText = metaAttributedText
        
        statusLabel.text = "Open now · Close \(restaurant.closesAt) · \(restaurant.distanceMeters) m"
        imageURLs = restaurant.heroImageURLs
        imagesCollection.reloadData()
        ImageLoader.shared.load(restaurant.reviewerURL) { [weak self] image in
            self?.reviewerImageView.image = image
        }
        reviewLabel.text = restaurant.reveiw
    }
}

extension RestaurantCardCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseID, for: indexPath) as! ImageCell
        cell.configure(url: imageURLs[indexPath.item])
        return cell
    }
}

private final class ImageCell: UICollectionViewCell {
    static let reuseID = "CardImageCell"
    
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configure(url: URL) {
        ImageLoader.shared.load(url) { [weak self] image in
            self?.imageView.image = image
        }
    }
}



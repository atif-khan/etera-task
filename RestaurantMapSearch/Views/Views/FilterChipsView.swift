import UIKit


/// Arrangement options for the content inside a filter chip.
enum ChipArrangement {
    case iconOnly
    case titleOnly
    case leadingIcon
    case trailingIcon
}

/// Simple identifier type for filter chips.
typealias FilterChipID = String

/// Configuration model for a single filter chip.
struct FilterChipConfiguration: Equatable {
    let id: FilterChipID
    let title: String?
    let icon: String?
    let arrangement: ChipArrangement
    let isInitiallySelected: Bool
}

/// A single pill‑shaped chip, matching the filter style from the design.
final class FilterChipView: UIControl {
    
    private let titleLabel = UILabel()
    private let iconView = UIImageView()
    private let stack = UIStackView()
    
    private let padding = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
    
    var configuration: FilterChipConfiguration {
        didSet { applyConfiguration() }
    }
    
    init(configuration: FilterChipConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        setupViews()
        applyConfiguration()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isSelected: Bool {
        didSet { updateAppearance() }
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.secondaryBackground
        layer.cornerRadius = 16
        layer.borderWidth = 1
        layer.borderColor = AppColors.secondaryBackground.cgColor
        
        titleLabel.font = .systemFont(ofSize: 13, weight: .medium)
        titleLabel.textColor = AppColors.primaryText
        
        iconView.tintColor = AppColors.primaryText
        iconView.contentMode = .scaleAspectFit
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        iconView.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.isUserInteractionEnabled = false
        
        addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor, constant: padding.top),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding.left),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding.right),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding.bottom),
        ])
    }
    
    private func applyConfiguration() {
        titleLabel.text = configuration.title
        
        stack.arrangedSubviews.forEach { stack.removeArrangedSubview($0); $0.removeFromSuperview() }
        
        switch configuration.arrangement {
        case .iconOnly:
            if let imageName = configuration.icon,
               let image = UIImage(named: imageName) {
                iconView.image = image
                stack.addArrangedSubview(iconView)
            }
        case .titleOnly:
            stack.addArrangedSubview(titleLabel)
        case .leadingIcon:
            if let imageName = configuration.icon,
               let image = UIImage(named: imageName) {
                iconView.image = image
                stack.addArrangedSubview(iconView)
            }
            stack.addArrangedSubview(titleLabel)
        case .trailingIcon:
            stack.addArrangedSubview(titleLabel)
            if let imageName = configuration.icon,
               let image = UIImage(named: imageName) {
                iconView.image = image
                stack.addArrangedSubview(iconView)
            }
        }
        
        isSelected = configuration.isInitiallySelected
        updateAppearance()
    }
    
    private func updateAppearance() {
        let baseBackground = AppColors.secondaryBackground
        let selectedBackground = AppColors.tint
        
        if isSelected {
            backgroundColor = selectedBackground
            layer.borderColor = UIColor.clear.cgColor
            titleLabel.textColor = AppColors.primaryText
            iconView.tintColor = AppColors.primaryText
        } else {
            backgroundColor = baseBackground
            layer.borderColor = AppColors.secondaryBackground.cgColor
            titleLabel.textColor = AppColors.primaryText
            iconView.tintColor = AppColors.primaryText
        }
        
    }
}

/// Horizontally scrolling collection of filter chips.
final class FilterChipsView: UIView {
    
    private let scrollView = UIScrollView()
    private let stackView = UIStackView()
    
    private var chipViews: [FilterChipID: FilterChipView] = [:]
    
    /// Called whenever a chip is tapped. Provides its id and new selection state.
    var onChipTapped: ((FilterChipID, Bool) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.background
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = false
        
        stackView.axis = .horizontal
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    /// Configure the chips to display.
    func configure(with configurations: [FilterChipConfiguration]) {
        stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
        chipViews.removeAll()
        
        for config in configurations {
            let chip = FilterChipView(configuration: config)
            chip.addTarget(self, action: #selector(handleTap(_:)), for: .touchUpInside)
            chipViews[config.id] = chip
            stackView.addArrangedSubview(chip)
        }
    }
    
    /// Imperatively set selection for a given chip id.
    func setSelected(_ isSelected: Bool, for id: FilterChipID) {
        guard let chip = chipViews[id] else { return }
        chip.isSelected = !chip.isSelected
    }
    
    @objc private func handleTap(_ sender: FilterChipView) {
        guard let (id, chip) = chipViews.first(where: { $0.value === sender }) else { return }
        chip.isSelected.toggle()
        onChipTapped?(id, chip.isSelected)
    }
}



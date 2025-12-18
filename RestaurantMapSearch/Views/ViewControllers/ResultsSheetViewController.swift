import UIKit

final class ResultsSheetViewController: UIViewController {
    
    enum Mode {
        case summary(title: String)
        case preview(restaurants: [Restaurant], selected: Restaurant, title: String)
        case list(restaurants: [Restaurant], title: String)
    }
    
    private let grabber = UIView()
    private let titleLabel = UILabel()
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private var mode: Mode = .summary(title: "") {
        didSet {render()}
    }
    
    var onSelect: ((UUID) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        
        grabber.translatesAutoresizingMaskIntoConstraints = false
        grabber.backgroundColor = AppColors.tint
        grabber.layer.borderWidth = 2
        grabber.layer.borderColor = AppColors.tint.cgColor
        grabber.layer.cornerRadius = 2
        
        titleLabel.font = .preferredFont(forTextStyle: .subheadline)
        titleLabel.numberOfLines = 1
        titleLabel.textColor = AppColors.secondaryText
        
        
        tableView.register(RestaurantCardCell.self, forCellReuseIdentifier: RestaurantCardCell.reuseID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = AppColors.tertiaryText
        tableView.separatorInset = .zero
        
        let grabberStackView = UIStackView(arrangedSubviews: [grabber])
        grabberStackView.axis = .vertical
        grabberStackView.alignment = .center
        
        
        let headerStack = UIStackView(arrangedSubviews: [grabberStackView, titleLabel])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        headerStack.alignment = .fill
        
        let stack = UIStackView(arrangedSubviews: [headerStack, tableView])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            grabber.widthAnchor.constraint(equalToConstant: 40),
            grabber.heightAnchor.constraint(equalToConstant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: headerStack.leadingAnchor,
                                                constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: headerStack.trailingAnchor,
                                                constant: -12),
            
            // Attach the content directly under the grabber so it moves
            // smoothly with the sheet height as the user drags.
            stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12)
        ])
        
        render()
    }
    
    func update(mode: Mode) {
        self.mode = mode
    }
    
    private func render() {
        switch mode {
        case .summary(let title):
            titleLabel.text = title
            titleLabel.textAlignment = .center
            tableView.isHidden = true
            
        case .preview(_, _, let title):
            titleLabel.text = title
            titleLabel.textAlignment = .left
            tableView.isHidden = false
            tableView.reloadData()
            
        case .list(_, let title):
            titleLabel.text = title
            titleLabel.textAlignment = .left
            tableView.isHidden = false
            tableView.reloadData()
            

        }
    }
    
    private func listItems() -> [Restaurant] {
        switch mode {
        case .list(let items, _):
            return items
        case .preview(let items, _, _):
            return items
        default:
            return []
        }
    }
}

extension ResultsSheetViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantCardCell.reuseID, for: indexPath) as! RestaurantCardCell
        let r = listItems()[indexPath.row]
        cell.configure(with: r)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let r = listItems()[indexPath.row]
        onSelect?(r.id)
    }
}

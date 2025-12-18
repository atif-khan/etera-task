import UIKit
import MapKit


final class RestaurantMapViewController: UIViewController {
    
    init(
        mapView: MKMapView = MKMapView(),
        viewModel: RestaurantSearchViewModel = RestaurantSearchViewModel(),
        sheetVC: ResultsSheetViewController = ResultsSheetViewController()
    ) {
        self.mapView = mapView
        self.viewModel = viewModel
        self.sheetVC = sheetVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Properties
    private let mapView: MKMapView
    private let viewModel: RestaurantSearchViewModel
    private let sheetVC: ResultsSheetViewController
    
    private let searchContainer = UIView()
    private let queryLabel = UILabel()
    private let locationLabel = UILabel()
    private let filterChipsView = FilterChipsView()
    
    private let collapsedDetentIdentifier = UISheetPresentationController.Detent.Identifier("collapsed")
    private var hasPresentedSheet = false
    private var isInitialLoad = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColors.background
        overrideUserInterfaceStyle = .dark
        
        setupNavigationBar()
        setupMapView()
        setupFilters()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure navigation bar is visible
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationBar() {
        // Configure navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.background
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        // Add back button
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = AppColors.primaryText
        
        // Setup search container as title view
        setupSearchBar()
    }
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupMapView() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Present the sheet only once, after the map controller is on screen.
        if !hasPresentedSheet {
            hasPresentedSheet = true
            presentSheet()
        }
        
    }
    
    private func setupSearchBar() {
        queryLabel.font = .preferredFont(forTextStyle: .subheadline)
        queryLabel.textColor = AppColors.primaryText
        
        locationLabel.font = .preferredFont(forTextStyle: .caption1)
        locationLabel.textColor = AppColors.secondaryText
        
        let textStack = UIStackView(arrangedSubviews: [queryLabel, locationLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false
        
        let searchImage = UIImageView(image: UIImage(named: "search"))
        let searchStack = UIStackView(arrangedSubviews: [searchImage, textStack])
        searchStack.axis = .horizontal
        searchStack.spacing = 8
        searchStack.alignment = .center
        searchStack.translatesAutoresizingMaskIntoConstraints = false
        
        searchContainer.addSubview(searchStack)
        searchContainer.backgroundColor = AppColors.secondaryBackground
        searchContainer.layer.cornerRadius = 24
        searchContainer.layer.shadowColor = AppColors.secondaryBackground.cgColor
        searchContainer.layer.shadowOpacity = 1.0
        searchContainer.layer.shadowOffset = CGSize(width: 0, height: 1)
        searchContainer.layer.shadowRadius = 2
        searchContainer.layer.masksToBounds = false

        // Create a parent view to hold the searchContainer with extra width/height and tint background.
        let parentView = UIView()
        parentView.backgroundColor = AppColors.tint
        parentView.layer.cornerRadius = 27
        parentView.addSubview(searchContainer)
        
        parentView.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.translatesAutoresizingMaskIntoConstraints = false

        // Set parent view as navigation bar title view
        navigationItem.titleView = parentView

        NSLayoutConstraint.activate([
            parentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            parentView.heightAnchor.constraint(equalToConstant: 54),
            
            searchContainer.leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: 2),
            searchContainer.trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -2),
            searchContainer.topAnchor.constraint(equalTo: parentView.topAnchor, constant: 1),
            searchContainer.bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -5),
            
            searchStack.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 8),
            searchStack.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 16),
            searchStack.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -16),
            searchStack.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -8),
            
            searchImage.heightAnchor.constraint(equalToConstant: 18),
            searchImage.widthAnchor.constraint(equalToConstant: 18),
        ])
        
        
        // Set search parentView as navigation bar title view
        navigationItem.titleView = parentView
    }
    
    private func setupFilters() {
        view.addSubview(filterChipsView)
        
        NSLayoutConstraint.activate([
            filterChipsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterChipsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterChipsView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterChipsView.heightAnchor.constraint(equalToConstant: 62)
        ])
        
        let chips: [FilterChipConfiguration] = [
            .init(id: "setting", title: "Setting", icon: "setting", arrangement: .iconOnly,  isInitiallySelected: false),
            .init(id: "sort", title: "Sort", icon: "sort", arrangement: .leadingIcon,  isInitiallySelected: false),
            .init(id: "map", title: "Map", icon: "map", arrangement: .iconOnly,  isInitiallySelected: false),
            .init(id: "cuisines", title: "Cuisines", icon: "dropdown", arrangement: .trailingIcon,  isInitiallySelected: false),
            .init(id: "brunch", title: "Brunch", icon: "dropdown", arrangement: .trailingIcon,  isInitiallySelected: false),
            .init(id: "distance", title: "Distance", icon: "dropdown", arrangement: .trailingIcon,  isInitiallySelected: false),
        ]
        
        filterChipsView.configure(with: chips)
        
        filterChipsView.onChipTapped = { [weak self] id, isSelected in
            guard self != nil else { return }
            switch id {
                //TODO: Add cases to handle events on filter selection/deselection
            default:
                break
            }
        }
        
    }
    
    private func bind() {
        // Bind the view model to the view
        viewModel.onChange = { [weak self] state in
            self?.apply(state)
        }
        apply(viewModel.state)
        
        // Bind the sheet view controller to the view
        sheetVC.onSelect = { [weak self] id in
            self?.viewModel.selectRestaurant(id: id)
            self?.centerMap(on: id)
        }
    }
    
    private func apply(_ state: RestaurantSearchViewModel.State) {
        queryLabel.text = state.query
        locationLabel.text = state.locationLabel
        
        let annotations = state.restaurants.map { RestaurantAnnotation(restaurant: $0) }
        
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
        
//        updateSheet(for: state, detent: sheetVC.sheetPresentationController?.selectedDetentIdentifier)
        if let restaurant = state.selectedRestaurant {
            updateSheetForSelected(selectedRestaurant: restaurant, title: state.title)
        }
        
        // Zoom to fit visible restaurants on initial load or when map region hasn't been set
        if isInitialLoad || mapView.region.span.latitudeDelta == 0 {
            zoomToFitRestaurants(annotations, animated: !isInitialLoad)
            isInitialLoad = false
        }
    }
    
    private func centerMap(on id: UUID) {
        guard let restaurant = viewModel.restaurant(with: id) else { return }
        mapView.setCenter(restaurant.coordinate, animated: true)
        
        if let annotation = mapView.annotations.first(where: { ($0 as? RestaurantAnnotation)?.restaurant.id == id }) {
            mapView.selectAnnotation(annotation, animated: true)
        }
    }
    
    /// Zooms the map to fit all visible restaurant annotations with appropriate padding.
    private func zoomToFitRestaurants(_ annotations: [RestaurantAnnotation], animated: Bool) {
        guard !annotations.isEmpty else { return }
        
        if annotations.count == 1 {
            // Single restaurant: center with reasonable zoom level
            let region = MKCoordinateRegion(
                center: annotations[0].coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
            mapView.setRegion(region, animated: animated)
        } else {
            // Multiple restaurants: calculate bounding box with padding
            let coordinates = annotations.map { $0.coordinate }
            
            let minLat = coordinates.map { $0.latitude }.min()!
            let maxLat = coordinates.map { $0.latitude }.max()!
            let minLon = coordinates.map { $0.longitude }.min()!
            let maxLon = coordinates.map { $0.longitude }.max()!
            
            let centerLat = (minLat + maxLat) / 2
            let centerLon = (minLon + maxLon) / 2
            let center = CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
            
            // Calculate span with padding (20% padding on each side = 1.4x multiplier)
            let latDelta = (maxLat - minLat) * 1.4
            let lonDelta = (maxLon - minLon) * 1.4
            
            // Ensure minimum span to prevent over-zooming
            let minSpan: CLLocationDegrees = 0.005
            let span = MKCoordinateSpan(
                latitudeDelta: max(latDelta, minSpan),
                longitudeDelta: max(lonDelta, minSpan)
            )
            
            let region = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(region, animated: animated)
        }
    }
    
    // Presenting sheetVC with UISheetPresentationController does not support to fully match the design.
    // TODO: Add the sheetVC as child VC and three different positions through animation and apply drag gesture.
    
    private func presentSheet() {
        sheetVC.isModalInPresentation = true
        sheetVC.modalPresentationStyle = .pageSheet
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.preferredCornerRadius = 20
            
            let collapsed = UISheetPresentationController.Detent.custom(identifier: collapsedDetentIdentifier) { _ in
                return 80
            }
            
            sheet.detents = [collapsed, .medium(), .large()]
            sheet.largestUndimmedDetentIdentifier = .large
            sheet.selectedDetentIdentifier = collapsedDetentIdentifier
            sheet.delegate = self
            
            // Start in summary state when sheet is collapsed.
            updateSheet(for: viewModel.state, detent: collapsedDetentIdentifier)
        }
        
        present(sheetVC, animated: true)
    }
    
    private func updateSheetForSelected(selectedRestaurant: Restaurant, title: String){
        sheetVC.update(mode: .preview(restaurants: viewModel.state.restaurants, selected: selectedRestaurant, title: title))
        
        if let sheet = sheetVC.sheetPresentationController {
            sheet.selectedDetentIdentifier = .medium
        }
    }
    
    private func updateSheet(
        for state: RestaurantSearchViewModel.State,
        detent: UISheetPresentationController.Detent.Identifier?
    ) {
        guard let detent else { return }
        //TODO: Count the number of restaurants from datasource
        // Currently using statics text
        
        switch detent {
        case collapsedDetentIdentifier:
            sheetVC.update(mode: .summary(title: state.title))
        default:
            if let selected = state.selectedRestaurant {
                sheetVC.update(mode: .preview(restaurants: state.restaurants,
                                              selected: selected, title: state.title))
            } else {
                sheetVC.update(mode: .list(restaurants: state.restaurants, title: state.title))
            }
        }
    }
}

extension RestaurantMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? RestaurantAnnotation else { return nil }
        
        let view = (mapView.dequeueReusableAnnotationView(withIdentifier: RestaurantAnnotationView.reuseID) as? RestaurantAnnotationView)
        ?? RestaurantAnnotationView(annotation: annotation, reuseIdentifier: RestaurantAnnotationView.reuseID)
        
        view.annotation = annotation
        view.configure(with: annotation.restaurant)
        return view
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? RestaurantAnnotation else { return }
        viewModel.selectRestaurant(id: annotation.restaurant.id)
    }
}

extension RestaurantMapViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(
        _ sheetPresentationController: UISheetPresentationController
    ) {
        updateSheet(for: viewModel.state, detent: sheetPresentationController.selectedDetentIdentifier)
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        false
    }
}


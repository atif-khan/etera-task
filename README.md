# RestaurantMapSearch (Xcode Project)

A minimal UIKit + MapKit sample demonstrating:
- Map annotations with avatar-style pins
- A bottom sheet (UISheetPresentationController) with detents
- Simple MVVM state sync between map selection and sheet

## Requirements
- Xcode 15+ (iOS 15+ deployment target)

## Run
1. Open `RestaurantMapSearch.xcodeproj`
2. Select an iPhone simulator
3. Run

## Notes
- Data is mocked in `Restaurant.sample()`.
- Image loading uses a basic in-memory cache (`ImageLoader`).
  In production, replace with a robust pipeline (Nuke/Kingfisher) and prefetching.

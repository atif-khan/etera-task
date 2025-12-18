## Challanges and Approach

### 1. UI Framwork Selection
**Challenge**: Choosing between SwiftUI and UIKit for building the app's views. SwiftUI offers a modern, declarative way of constructing UIs, promising faster iteration and better preview support, but I am less familier with it. UIKit is more established, deeply documented, more verbose and imperative, and I have good familierity with it.

**Approach**: We'll use UIKit for this project because I am more familiar with it and can move faster and more confidently with UIKit's APIs—particularly for custom UI and advanced view controller behaviors like the results sheet and filter chips. Crucially, we'll architect our views to be decoupled from both the business logic (ViewModel) and the data/network layers; this way, we can refactor or replace individual view components with SwiftUI in the future with minimal changes elsewhere. By maintaining clean boundaries between UI and the rest of the application, we’ll keep open the possibility of adopting SwiftUI later if needed or as it matures.


### 2. Architectural & Design Challenge
**Challenge**: Decide how to structure data sources, services, and view controllers while keeping business logic separate from the UI so that views can be changed without breaking other layers.  
**Approach**: We will use a layered architecture with clear separation of concerns: 'Models' will have the data/entities and services/APIs, 'ViewModel' will contain the business logic and state, and 'Views' will be responsible only for rendering UI and user interaction. Views will communicate with the view model via inputs (user actions) and will observe outputs (state changes), which should allow us to modify or replace view implementations with minimal impact on networking or business logic.

### 3. Complex UI: Filter Chips and Page Sheet
**Challenge**: Designing the chips-based filter UI and the results PageSheet is non-trivial and requires behavior that standard UIKit controls do not provide out of the box.  
**Approach**: We will implement custom UI components such as `FilterChipsView`, a reusable control for displaying and managing selectable chips, and a tailored `ResultsSheetViewController` that behaves like a sheet over the map. These components will encapsulate their own layout, selection state, and interaction logic, exposing a clean API back to the view controller / view model. This should keep the complex UI manageable, testable, and easier to iterate on visually.

### 4. Image Caching for Performance
**Challenge**: If we load restaurant images directly from the network on every appearance, this will cause unnecessary latency and scrolling jank, especially in a list of many restaurants.  
**Approach**: We will introduce an `ImageLoader` service with in-memory caching. Images will be fetched asynchronously and stored in a cache keyed by URL; subsequent requests for the same image will return the cached version instead of re-hitting the network. This is expected to improve scrolling performance, reduce bandwidth usage, and keep the UI responsive.


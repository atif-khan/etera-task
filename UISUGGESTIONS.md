# UI/UX Design Suggestions

### Search Field
The search field is showing the restaurant name and location, which looks like a search result state. What would be the state when the user taps on the search field?

### Map Marker
Restaurant markers rely heavily on images. I would suggest avoiding images here and instead using a restaurant icon for performance considerations. I would also suggest using other attributes such as rating, price range, and cuisine.

### Filter Chips
All filter content is not identical. Some filters have icons only, while others have both an icon and a title. We may group the chips based on their purpose and ensure users clearly understand them through either the icon or the title.  

Additionally, no view is provided for the post-tap state.

### Bottom Sheet
Since native controls do not support the provided bottom sheet UI/UX, I would suggest keeping the design closer to native controls. This will reduce developer effort and provide a more native look and feel.  

In the full-screen state, no drag handle is visible, making it unclear how to minimize the bottom sheet.

### Empty & Loading States
There is no visible handling for loading, filtering, or zero-result states. I would challenge how these scenarios are communicated to users.

### Fonts and Colors
For font names, sizes, weights, and color values, I suggest using consistent naming conventions across both the design assets (such as Figma) and the codebase. Instead of referencing explicit values. This ensures better consistency, minimizes the risk of mismatch, and accelerates the development process. All fonts and colors should reference these reusable tokens rather than hard-coded values, and Figma resources should use the same naming scheme to streamline handoff and prevent ambiguity.

### UI Component Library
When designing UI components, please consider their potential for reusability. If a component is, or could be, reused in multiple places (for example: buttons, input fields, filter chips, cards, etc.), create a separate design file for that component detailing all possible use cases, states, and variants.  

This dedicated component file should define:
- The various states (default, hover, active, disabled, error, loading, etc.)
- Different sizes or modes (if applicable)
- Allowed customizations (icon slots, labels, colors, etc.)
- Usage guidelines and placement examples

During development, the developer will implement this as a separate and reusable component in the codebase. All screens that require this pattern should use the same reusable component instance, not duplicate code or markup.  

This approach streamlines UI development, ensures consistency across the app, reduces bugs, and accelerates new feature development by building up a stable, well-documented UI component library.

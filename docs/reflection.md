# Project Reflection

## Course Topics Applied
We applied a variety of CSE 340 topics in our project, including:
- **State Management:** Used the Provider pattern for reactive UI updates and clean separation of concerns.
- **Data Persistence:** Integrated the Isar database for local, persistent storage of outfits and clothing items.
- **API Integration:** Queried the National Weather Service API to fetch real-time weather data.
- **Sensor Access:** Used the device's GPS sensor to provide location-based weather and outfit suggestions.
- **Undo/Redo:** Implemented undo and redo functionality for outfit deletion and management.
- **Internationalization:** Added support for multiple languages (English and Spanish planned).

### Accessibility Implementation
- Used contrast checkers and accessibility tools to evaluate and improve color contrast and UI clarity.
- Added form labels and UI signifiers to aid users with navigation and screen readers.
- Addressed feedback from accessibility audits, including plans to add a border around the temperature box for better contrast.

### Technical Implementation
- Used IsarLinks to manage relationships between outfits and clothing items in the database.
- Employed transaction-based operations for data consistency.
- Utilized Material Design 3 for a modern, accessible UI.
- Periodic weather updates and robust error handling for a smooth user experience.

## Resources and Acknowledgments
- **External Libraries:** Isar, Provider, GeoLocator, HTTP
- **Course Resources:** FoodFinder, Journal, Drawing assignment starter code
- **Accessibility Tools:** Contrast checkers, accessibility inspector, screen reader

## Learning Outcomes
- Gained hands-on experience with state management, persistent storage, and API integration in Flutter.
- Deepened understanding of accessibility best practices and the importance of usability testing.
- Learned to iteratively refine the app based on user and audit feedback.

## Design Evolution
- The original concept focused on basic outfit storage and weather-based suggestions.
- Through user testing and audits, we added undo/redo, improved accessibility, and enhanced UI clarity.
- Addressed technical challenges with IsarLinks and state management for complex data relationships.

## Refinement
To improve usability, we implemented **undo & redo** for outfit management, added form labels, and included UI signifiers for navigation. We also addressed accessibility audit feedback, such as improving color contrast and planning a border around the temperature box.

**Main challenge:** Handling multiple Isar databases and ensuring all clothing items loaded correctly for each outfit. We used IsarLinks to manage these relationships and maintain state consistency.

## Future Work
Making it so that you can reuse articles of clothing (like a search bar that filters by word) so that if you are already adding the same thing we can reduce the number of items in Isar

Then making it so that users can add their own colors

## CSE 340 Reflection
The most valuable takeaway from CSE 340 was learning how to design and build accessible, user-centered applications. Usability and accessibility are critical for real-world impact. Advice for future students: start early, test with real users, and always consider accessibility from the beginning.
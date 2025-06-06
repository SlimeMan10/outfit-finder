# Outfit Finder

## About This App
Outfit Finder is a Flutter application that helps users choose appropriate clothing based on current weather conditions and location. The app provides real-time outfit suggestions, maintains a digital wardrobe, and offers location-aware clothing recommendations.

## Features
- Real-time weather-based outfit suggestions
- Location-aware clothing recommendations
- Digital wardrobe management
- Sample outfits for different weather conditions
- Persistent storage using Isar database
- Provider-based state management
- Weather condition filtering (Sunny, Gloomy, Rainy, Slightly Cloudy)
- Temperature tracking (current, high, low)
- Automatic weather updates every 70 seconds
- Undo/redo functionality for outfit management
- Internationalization support (English, Spanish)

## Team Members
- Abigail Lew (alew4@uw.edu)
- Samuel Lopez (sam816@uw.edu)
- Justin Hernandez Tovalin (jherna3@uw.edu)
- Joel Gomes (jgomes66@uw.edu)

## Build Instructions
1. Clone this repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## Requirements
- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode for mobile development
- Weather API key (to be provided via Edstem)
- Location services enabled on device
- Internet connection for weather updates

## API Keys
Note: Weather API key should be sent via private message on Edstem to the course staff.

## Project Layout
### Core Features
- `lib/main.dart` - Entry point and app initialization
- `lib/views/` - Screen widgets and main UI components
  - `outfit_finder_app.dart` - Main app widget
  - `outfit_view.dart` - Outfit display and management
  - `weather_filter_view.dart` - Weather-based filtering
- `lib/widgets/` - Reusable widget components
  - `custom_top_bar.dart` - App navigation and filtering
  - `outfit_card.dart` - Outfit display card
  - `clothing_item_widget.dart` - Clothing item display
  - `section_header.dart` - Section headers
- `lib/models/` - Data models and structures
  - `outfit.dart` - Outfit data model
  - `clothing_item.dart` - Clothing item data model
  - `wardrobe.dart` - Wardrobe management
- `lib/providers/` - State management providers
  - `position_provider.dart` - Location management
  - `weather_provider.dart` - Weather data management
  - `database_provider.dart` - Outfit data management
- `lib/helper/` - Utility functions and helpers
  - `isar_helper.dart` - Database initialization
  - `weather_checker.dart` - Weather API integration
  - `color_helper.dart` - Color management
- `lib/components/` - UI components
  - `weather_filter.dart` - Weather filtering component

### Assets
- `assets/images/` - Image assets
- `assets/fonts/` - Custom fonts
- `assets/icons/` - App icons
- `assets/l10n/` - Localization files

### Documentation
- `docs/` - Project documentation
  - `need.md` - Human need documentation
  - `data.md` - Data design and flow
  - `evaluation.md` - Usability evaluation
  - `audit_changes.md` - Accessibility audit changes
  - `reflection.md` - Project reflection

## Development
The app uses:
- Provider pattern for state management
- Isar for local database
- Weather API for real-time weather data
- Location services for GPS tracking
- Material Design 3 for UI components
- Periodic weather updates (70-second intervals)
- Transaction-based database operations
- Error handling and fallback states
- Loading state management
- Proper resource cleanup
- Internationalization support
- Undo/redo functionality

## Contributing
This is a course project for CSE 340. Please refer to the course documentation for contribution guidelines.

## License
This project is part of the CSE 340 course at the University of Washington.
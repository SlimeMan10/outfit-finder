/// Enum representing different weather conditions used throughout the application.
/// 
/// This enum is used to categorize and display weather states in the UI
/// and for weather-based outfit recommendations.
/// 
/// Values:
/// - unknown: Default state when weather cannot be determined
/// - sunny: Clear, bright weather conditions
/// - slightlyCloudy: Partially cloudy conditions
/// - gloomy: Overcast or heavily cloudy conditions
/// - rainy: Precipitation conditions
enum WeatherCondition {
  /// Default state when weather cannot be determined
  unknown,
  /// Clear, bright weather conditions
  sunny,
  /// Partially cloudy conditions
  slightlyCloudy,
  /// Overcast or heavily cloudy conditions
  gloomy,
  /// Precipitation conditions
  rainy;

  /// Converts the weather condition to a human-readable string.
  /// 
  /// Returns: A string representation of the weather condition
  /// suitable for display in the UI
  @override
  String toString() {
    switch (this) {
      case WeatherCondition.unknown:
        return 'Unknown';
      case WeatherCondition.sunny:
        return 'Sunny';
      case WeatherCondition.slightlyCloudy:
        return 'Partly Cloudy';
      case WeatherCondition.gloomy:
        return 'Gloomy';
      case WeatherCondition.rainy:
        return 'Rainy';
    }
  }
}
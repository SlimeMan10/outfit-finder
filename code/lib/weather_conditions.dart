/// Different weather conditions used in the app
/// - unknown: Weather not determined
/// - gloomy: Cloudy weather
/// - sunny: Clear weather
/// - rainy: Rainy weather
/// - slightlyRainy: Slightly rainy weather
enum WeatherCondition {
  /// Unknown weather condition
  unknown,
  /// Sunny weather condition
  sunny,
  /// Slightly cloudy weather condition
  slightlyCloudy,
  /// Gloomy weather condition
  gloomy,
  /// Rainy weather condition
  rainy;

  /// use WeatherConditions.<condition>.toString() to get string representation
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
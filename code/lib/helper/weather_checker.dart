import 'dart:async';
import 'dart:convert';
import 'package:outfit_finder/providers/weather_provider.dart';
import 'package:http/http.dart' as http;
import 'package:outfit_finder/weather_conditions.dart';

//ignore_for_file: avoid_print

/// Gets weather data from API
class WeatherChecker {
  // Provider to update
  final WeatherProvider weatherProvider;
  
  // Current location
  double _latitude = 47.96649; // Allen Center
  double _longitude = -122.34318;
  
  // HTTP client
  http.Client? client;

  /// Creates WeatherChecker
  /// Parameters:
  ///   - weatherProvider: Provider to update
  ///   - client: HTTP client for testing
  WeatherChecker(this.weatherProvider, {this.client});

  /// Updates location
  /// Parameters:
  ///   - latitude: New latitude
  ///   - longitude: New longitude
  void updateLocation(double latitude, double longitude) {
    _latitude = latitude;
    _longitude = longitude;
  }

  /// Gets weather data from API
  Future<void> fetchAndUpdateCurrentSeattleWeather() async {
    try {
      final http.Client client = this.client ?? http.Client();
      
      final gridResponse = await client.get(
          Uri.parse('https://api.weather.gov/points/$_latitude,$_longitude'));
      final gridParsed = (jsonDecode(gridResponse.body));
      final String? forecastURL = gridParsed['properties']?['forecast'];
      
      if (forecastURL == null) {
        weatherProvider.updateWeather(0, 0, 0, WeatherCondition.unknown);
        return;
      }
      
      final weatherResponse = await client.get(Uri.parse(forecastURL));
      final weatherParsed = jsonDecode(weatherResponse.body);
      final currentPeriod = weatherParsed['properties']?['periods']?[0];
      
      if (currentPeriod != null) {
        final temperature = currentPeriod['temperature'];
        final shortForecast = currentPeriod['shortForecast'];
        final highTemp = currentPeriod['temperature'];
        final lowTemp = weatherParsed['properties']?['periods']?[1]?['temperature'] ?? temperature;
        
        if (temperature != null && shortForecast != null) {
          final condition = _shortForecastToCondition(shortForecast);
          weatherProvider.updateWeather(temperature, highTemp, lowTemp, condition);
        } else {
          weatherProvider.updateWeather(0, 0, 0, WeatherCondition.unknown);
        }
      } else {
        weatherProvider.updateWeather(0, 0, 0, WeatherCondition.unknown);
      }
    } catch (_) {
      weatherProvider.updateWeather(0, 0, 0, WeatherCondition.unknown);
    } finally {
      client?.close();
      client = null;
    }
  }

  /// Converts forecast text to condition
  /// Parameters:
  ///   - shortForecast: Weather description
  /// Returns: Weather condition
  WeatherCondition _shortForecastToCondition(String shortForecast) {
    final lowercased = shortForecast.toLowerCase();
    if (lowercased.startsWith('rain')) return WeatherCondition.rainy;
    if (lowercased.startsWith('sun') || lowercased.startsWith('partly')) {
      return WeatherCondition.sunny;
    }
    return WeatherCondition.gloomy;
  }
}

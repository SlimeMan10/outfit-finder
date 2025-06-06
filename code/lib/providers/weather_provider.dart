/// Manages weather data and updates for the application.
/// This provider handles fetching, storing, and updating weather information
/// including temperature and conditions.
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:outfit_finder/helper/weather_checker.dart';
import 'package:outfit_finder/weather_conditions.dart';

/// Manages weather data for the app
class WeatherProvider extends ChangeNotifier {
  /// Current temperature in Fahrenheit
  int _tempInFahrenheit = 0;

  /// High temperature for the day in Fahrenheit
  int _highTempInFahrenheit = 0;

  /// Low temperature for the day in Fahrenheit
  int _lowTempInFahrenheit = 0;

  /// Current weather condition (e.g., sunny, rainy, gloomy)
  WeatherCondition _condition = WeatherCondition.unknown;

  /// Weather checker instance
  late final WeatherChecker _check;

  /// Weather data loading state
  bool _loading = false;

  /// Timer for updates
  Timer? _timer;

  /// Getters
  int get tempInFahrenheit => _tempInFahrenheit;
  WeatherCondition get condition => _condition;
  bool get loading => _loading;
  int get highTempFahrenheit => _highTempInFahrenheit;
  int get lowTempFahrenheit => _lowTempInFahrenheit;

  /// Creates WeatherProvider and starts updates
  WeatherProvider() {
    _tempInFahrenheit = 0;
    _condition = WeatherCondition.unknown;
    _loading = false;
    notifyListeners();
    
    _check = WeatherChecker(this);
    _scheduleInitialWeatherFetch();
    
    _timer = Timer.periodic(const Duration(seconds: 70), (timer) {
      _scheduleWeatherFetch();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Schedules initial weather fetch
  void _scheduleInitialWeatherFetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAndUpdateCurrentSeattleWeather();
    });
  }

  /// Schedules weather fetch
  void _scheduleWeatherFetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAndUpdateCurrentSeattleWeather();
    });
  }

  /// Fetches and updates weather data
  Future<void> fetchAndUpdateCurrentSeattleWeather() async {
    if (_loading) return;
    
    _setLoading(true);
    
    try {
      await _check.fetchAndUpdateCurrentSeattleWeather();
    } catch (error) {
      _updateWeatherState(0, 0, 0, WeatherCondition.unknown);
    }
  }

  /// Updates loading state
  /// Parameters:
  ///   - isLoading: New loading state
  void _setLoading(bool isLoading) {
    if (_loading != isLoading) {
      _loading = isLoading;
      notifyListeners();
    }
  }

  /// Updates weather data
  /// Parameters:
  ///   - newTempFahrenheit: New temperature
  ///   - newHighTempFahrenheit: New high temperature
  ///   - newLowTempFahrenheit: New low temperature
  ///   - newCondition: New weather condition
  void updateWeather(int newTempFahrenheit, int newHighTempFahrenheit, int newLowTempFahrenheit, WeatherCondition newCondition) {
    _updateWeatherState(newTempFahrenheit, newHighTempFahrenheit, newLowTempFahrenheit, newCondition);
  }

  /// Updates weather state
  /// Parameters:
  ///   - newTempFahrenheit: New temperature
  ///   - newHighTempFahrenheit: New high temperature
  ///   - newLowTempFahrenheit: New low temperature
  ///   - newCondition: New weather condition
  void _updateWeatherState(int newTempFahrenheit, int newHighTempFahrenheit, int newLowTempFahrenheit, WeatherCondition newCondition) {
    bool hasChanges = false;
    
    if (_tempInFahrenheit != newTempFahrenheit) {
      _tempInFahrenheit = newTempFahrenheit;
      hasChanges = true;
    }
    
    if (_highTempInFahrenheit != newHighTempFahrenheit) {
      _highTempInFahrenheit = newHighTempFahrenheit;
      hasChanges = true;
    }
    
    if (_lowTempInFahrenheit != newLowTempFahrenheit) {
      _lowTempInFahrenheit = newLowTempFahrenheit;
      hasChanges = true;
    }
    
    if (_condition != newCondition) {
      _condition = newCondition;
      hasChanges = true;
    }
    
    _loading = false;
    
    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Updates location for weather checks
  /// Parameters:
  ///   - latitude: New latitude
  ///   - longitude: New longitude
  void updateLocation(double latitude, double longitude) {
    _check.updateLocation(latitude, longitude);
    _scheduleWeatherFetch();
  }
}
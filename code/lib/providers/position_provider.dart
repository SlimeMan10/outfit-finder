/// Manages the user's location for the application.
/// This provider handles location permissions, updates, and provides
/// access to the current position coordinates.
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Manages user location for the app
class PositionProvider extends ChangeNotifier {
  /// Current latitude coordinate of the user's position
  double _latitude = 0.0;
  
  /// Current longitude coordinate of the user's position
  double _longitude = 0.0;
  
  /// Flag indicating whether a valid position has been obtained
  bool _hasPosition = false;

  /// Timer for periodic position updates
  Timer? _timer;

  /// Getter for the current latitude
  double get latitude => _latitude;
  
  /// Getter for the current longitude
  double get longitude => _longitude;
  
  /// Getter for the position validity status
  bool get hasPosition => _hasPosition;

  /// Creates a new PositionProvider instance and starts periodic position updates.
  /// Updates occur every 60 seconds.
  PositionProvider() {
    _determinePosition();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _determinePosition();
    });
  }

  /// Cleans up resources when the provider is disposed.
  /// Cancels the position update timer.
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Determines the current position of the device.
  /// This method handles:
  /// - Checking if location services are enabled
  /// - Requesting location permissions if needed
  /// - Updating position coordinates if they've changed
  /// - Notifying listeners of any changes
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasPosition = false;
      notifyListeners();
      return;
    }

    // Check and request location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasPosition = false;
        notifyListeners();
        return;
      }
    }
    
    // Handle permanently denied permissions
    if (permission == LocationPermission.deniedForever) {
      _hasPosition = false;
      notifyListeners();
      return;
    }

    // Get current position and update if changed
    try {
      final position = await Geolocator.getCurrentPosition();
      if (_latitude != position.latitude || _longitude != position.longitude) {
        _latitude = position.latitude;
        _longitude = position.longitude;
        _hasPosition = true;
        notifyListeners();
      }
    } catch (e) {
      _hasPosition = false;
      notifyListeners();
    }
  }
}
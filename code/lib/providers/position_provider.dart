import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Manages user location for the app
class PositionProvider extends ChangeNotifier {
  // Current latitude
  double _latitude = 0.0;
  
  // Current longitude
  double _longitude = 0.0;
  
  // Has valid location
  bool _hasPosition = false;

  // Update timer
  Timer? _timer;

  // Getters
  double get latitude => _latitude;
  double get longitude => _longitude;
  bool get hasPosition => _hasPosition;

  /// Creates PositionProvider and starts updates
  PositionProvider() {
    _determinePosition();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      _determinePosition();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Gets current device location
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _hasPosition = false;
      notifyListeners();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _hasPosition = false;
        notifyListeners();
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      _hasPosition = false;
      notifyListeners();
      return;
    }

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
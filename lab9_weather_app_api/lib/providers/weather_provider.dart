import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _service = WeatherService();
  WeatherData? _weather;
  bool _isLoading = false;
  String? _error;
  String _currentCity = "Bangkok";
  int _viewIndex = 0;

  WeatherData? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get currentCity => _currentCity;
  int get viewIndex => _viewIndex;

  void setViewIndex(int index) {
    _viewIndex = index;
    notifyListeners();
  }

  Future<void> fetchWeatherByLocation(double lat, double lon, String cityName) async {
    _isLoading = true;
    _error = null;
    _currentCity = cityName;
    notifyListeners();
    try {
      _weather = await _service.fetchWeather(lat, lon);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchCity(String cityName) async {
    if (cityName.isEmpty) return;
    _isLoading = true;
    notifyListeners();
    try {
      final coords = await _service.getCoordsFromCity(cityName);
      if (coords != null) {
        await fetchWeatherByLocation(coords['latitude'], coords['longitude'], coords['name']);
      } else {
        _error = "ไม่พบข้อมูลจังหวัดที่คุณค้นหา";
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _error = "เกิดข้อผิดพลาดในการค้นหา";
      _isLoading = false;
      notifyListeners();
    }
  }

  Color get backgroundColor {
    if (_weather == null) return Colors.blueGrey;
    double temp = _weather!.currentTemp;
    if (temp >= 35) return Colors.orangeAccent;
    if (temp >= 25) return Colors.lightBlueAccent;
    return Colors.blueGrey.shade400;
  }
}

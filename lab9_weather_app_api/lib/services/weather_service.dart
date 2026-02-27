import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_model.dart';

class WeatherService {
  static const String baseUrl = "https://api.open-meteo.com/v1/forecast";
  static const String geoUrl = "https://geocoding-api.open-meteo.com/v1/search";

  Future<WeatherData> fetchWeather(double lat, double lon) async {
    final url =
        "$baseUrl?latitude=$lat&longitude=$lon&current=temperature_2m,weather_code&daily=weather_code,temperature_2m_max,temperature_2m_min&timezone=auto";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // ค้นหาพิกัดจากชื่อเมือง
  Future<Map<String, dynamic>?> getCoordsFromCity(String cityName) async {
    final url = "$geoUrl?name=$cityName&count=1&language=en&format=json";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'] != null && data['results'].isNotEmpty) {
        return data['results'][0];
      }
    }
    return null;
  }
}

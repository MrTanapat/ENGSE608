class WeatherData {
  final double currentTemp;
  final int weatherCode;
  final List<DailyForecast> daily;

  WeatherData({required this.currentTemp, required this.weatherCode, required this.daily});

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    var dailyData = json['daily'];
    List<DailyForecast> tempDaily = [];
    for (int i = 0; i < (dailyData['time'] as List).length; i++) {
      tempDaily.add(DailyForecast(
        date: dailyData['time'][i],
        maxTemp: dailyData['temperature_2m_max'][i],
        minTemp: dailyData['temperature_2m_min'][i],
        code: dailyData['weather_code'][i],
      ));
    }
    return WeatherData(
      currentTemp: json['current']['temperature_2m'],
      weatherCode: json['current']['weather_code'],
      daily: tempDaily,
    );
  }
}

class DailyForecast {
  final String date;
  final double maxTemp;
  final double minTemp;
  final int code;

  DailyForecast({required this.date, required this.maxTemp, required this.minTemp, required this.code});
}

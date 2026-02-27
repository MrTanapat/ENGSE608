import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});
  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<WeatherProvider>().fetchWeatherByLocation(13.75, 100.51, "Bangkok"));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: provider.backgroundColor,
      appBar: AppBar(
        title: Text(provider.currentCity, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ส่วน Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white24,
                hintText: "พิมพ์ชื่อจังหวัด (ภาษาอังกฤษ)...",
                hintStyle: const TextStyle(color: Colors.white70),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    provider.searchCity(_searchController.text);
                    _searchController.clear();
                  },
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (value) {
                provider.searchCity(value);
                _searchController.clear();
              },
            ),
          ),
          
          SegmentedButton<int>(
            segments: const [
              ButtonSegment(value: 0, label: Text('Current'), icon: Icon(Icons.now_widgets)),
              ButtonSegment(value: 1, label: Text('10-Day'), icon: Icon(Icons.calendar_month)),
            ],
            selected: {provider.viewIndex},
            onSelectionChanged: (Set<int> newSelection) => provider.setViewIndex(newSelection.first),
          ),

          Expanded(
            child: provider.isLoading 
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : provider.error != null
                ? Center(child: Text(provider.error!, style: const TextStyle(color: Colors.white)))
                : provider.viewIndex == 0 
                  ? _buildCurrentView(provider) 
                  : _buildForecastView(provider),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentView(WeatherProvider provider) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wb_cloudy_outlined, size: 100, color: Colors.white),
        Text('${provider.weather!.currentTemp}°C', 
             style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: Colors.white)),
        const Text('สภาพอากาศปัจจุบัน', style: TextStyle(fontSize: 24, color: Colors.white70)),
      ],
    );
  }

  Widget _buildForecastView(WeatherProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.weather!.daily.length,
      itemBuilder: (context, index) {
        final daily = provider.weather!.daily[index];
        return Card(
          color: Colors.white12,
          child: ListTile(
            title: Text(daily.date, style: const TextStyle(color: Colors.white)),
            trailing: Text('${daily.maxTemp}° / ${daily.minTemp}°', 
                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        );
      },
    );
  }
}

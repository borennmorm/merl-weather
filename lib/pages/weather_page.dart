// ignore_for_file: constant_pattern_never_matches_value_type

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:my_weather_app/service/weather_service.dart';

import '../model/weath_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService =
      WeatherService('25e440d83a3e5c05870b3ddef427d7d9'); // API Key
  Weather? _weather;

  // Fetch weather for the current location
  _fetchWeather() async {
    try {
      // Get current position (latitude and longitude)
      Position position = await _weatherService.getCurrentPosition();

      // Get weather data for the current position
      final weather = await _weatherService.getWeatherByCoordinates(
          position.latitude, position.longitude);

      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  // weather animation
  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return "assets/sunny.json";

    switch (mainCondition.toLowerCase) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/windy.json";
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return "assets/rain.json";
      case 'thunderstorm':
        return "assets/thunder.json";
      case 'clear':
        return "assets/sunny.json";
      default:
        return "assets/sunny.json";
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // City name
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(color: Colors.white, fontSize: 25),
            ),

            const SizedBox(
              height: 20,
            ),

            // animation
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition),
                width: 200),

            // Temperature
            Text('${_weather?.temperature.round() ?? ""}°C',
                style: const TextStyle(color: Colors.white, fontSize: 36)),

            // weather condition
            Text(_weather?.mainCondition ?? "",
                style: const TextStyle(color: Colors.white, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}

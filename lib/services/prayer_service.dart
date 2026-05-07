import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';

class PrayerService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.aladhan.com/v1'));

  Future<Map<String, dynamic>> getPrayerTimings(Position position) async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      final response = await _dio.get(
        '/timings/$date',
        queryParameters: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'method': 2,
        },
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load prayer timings');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTimingsByAddress(String address) async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      final response = await _dio.get(
        '/timingsByAddress/$date',
        queryParameters: {
          'address': address,
          'method': 2,
        },
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load timings by address');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getNextPrayerByAddress(String address) async {
    // This is often used for specific next prayer info
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      // Note: Aladhan doesn't have a direct /nextPrayer endpoint, 
      // but we can get timings and calculate or use their specialized ones if available.
      // Based on user request, we use the pattern they provided.
      final response = await _dio.get(
        '/timingsByAddress/$date',
        queryParameters: {
          'address': address,
          'method': 2,
        },
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load next prayer');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTimingsByCity(String city, String country) async {
    final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    try {
      final response = await _dio.get(
        '/timingsByCity/$date',
        queryParameters: {
          'city': city,
          'country': country,
          'method': 2, // Using method 2 as requested in your latest URL
        },
      );
      if (response.statusCode == 200) {
        return response.data['data'];
      }
      throw Exception('Failed to load timings by city');
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, String>> getCityAndCountryFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      
      String city = place.locality ?? place.subAdministrativeArea ?? place.administrativeArea ?? "Unknown City";
      String country = place.country ?? "Unknown Country";
      
      return {
        'city': city,
        'country': country,
      };
    } catch (e) {
      return {
        'city': 'Dhaka',
        'country': 'Bangladesh',
      };
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<String> getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      Placemark place = placemarks[0];
      // Show City, Country (e.g., Dhaka, Bangladesh)
      String city = place.locality ?? place.subAdministrativeArea ?? "";
      String country = place.country ?? "";
      if (city.isNotEmpty) {
        return "$city, $country";
      } else {
        return country;
      }
    } catch (e) {
      return "Unknown Location";
    }
  }
}

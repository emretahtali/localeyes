import 'dart:convert';
import 'package:http/http.dart' as http;

class GeocodingService {
  final String apiKey =
      'AIzaSyC5trTnLdaLO1SY5cK451pVsizWgPD0vXQ'; // Google API anahtarınızı buraya koyun

  Future<Map<String, dynamic>?> getLatLongFromAddress(
      String address, String city) async {
    final String url =
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final location = data['results'][0]['geometry']['location'];
          return {
            "name": address,
            'latitude': location['lat'],
            'longitude': location['lng'],
          };
        } else {
          print('Geocoding API error: ${data['status']}');
        }
      } else {
        print('HTTP request failed: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
    return null;
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:imaginecup/core/constants/api_constants.dart';

// Azure ayarlarını burada tanımlayın
class AzureService {
  Future<Map<String, dynamic>?> createAITrip(
      String destinationCity, int numDays) async {
    try {
      final body = json.encode({
        "messages": [
          {
            "role": "system",
            "content": "You are an travel route planner asistant."
          },
          {
            "role": "user",
            "content": """
Please provide a route for $numDays days in $destinationCity. The places should be categorized as Historical Sites, Nature and Open Spaces, Modern and Entertainment Venues, Museums, Restaurants that serve traditional dishes well. Provide the response in JSON format for each category and add address, name , and description for each place. Do it day by day and add all category to each day. Json format obliged to be: Map<String,dynamic>. example: {
  "day1": {
    "places": [
      {
        "name": "Place 1",
        "kind": "historical",
        "info": "Description about the historical importance of Place 1",
        "address": "Address of Place 1"
      },
      {
        "name": "Place 2",
        "kind": "nature",
        "info": "Details about the natural beauty or activities in Place 2",
        "address": "Address of Place 2"
      }
    ],
    "restaurants": [
      {
        "name": "Restaurant 1",
        "kind": "traditional",
        "info": "Details about the traditional dishes served here",
        "address": "Address of Restaurant 1"
      }
    ]
  },
  "day2": {
    "places": [
      {
        "name": "Place 3",
        "kind": "museum",
        "info": "Brief about the exhibits and history of Museum 3",
        "address": "Address of Museum 3"
      },
      {
        "name": "Place 4",
        "kind": "modern",
        "info": "Description about modern entertainment activities at Place 4",
        "address": "Address of Place 4"
      }
    ],
    "restaurants": [
      {
        "name": "Restaurant 2",
        "kind": "fusion",
        "info": "Details about the mix of traditional and modern cuisines",
        "address": "Address of Restaurant 2"
      }
    ]
  }
}
"""
          }
        ],
        "max_tokens": 5000 // max token ne olsun?????
      });

      // Endpoint URL'si
      final endpoint =
          '$apiBase/openai/deployments/$deploymentName/chat/completions';

      final uri = Uri.parse('$endpoint?api-version=$apiVersion');

      // HttpClient oluşturuluyor
      final httpClient = HttpClient();
      final request = await httpClient.postUrl(uri);

      // Başlıklar ekleniyor
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('api-key', apiKey);

      // Gövde ekleniyor (UTF-8 olarak kodlanıyor)
      request.add(utf8.encode(body));

      // Yanıt bekleniyor
      final response = await request.close();

      // Yanıt gövdesini bir kez okuyup saklama
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode == 200) {
        print("AI Response: $responseBody");

        try {
          // Yanıtı parse etme
          final jsonData = json.decode(responseBody);
          final content = jsonData['choices'][0]['message']['content'];

          // JSON içeriği ayıklama
          final jsonMatch =
              RegExp(r'```json\n(.*?)```', dotAll: true).firstMatch(content);
          if (jsonMatch != null) {
            final jsonString = jsonMatch.group(1)!;
            final parsedData = json.decode(jsonString);

            //var parsedJsonFormatted = const JsonEncoder.withIndent('  ').convert(parsedData);

            //print("Parsed JSON Data:\n$parsedJsonFormatted");
            return parsedData;
          } else {
            print("Content: $content");
          }
        } catch (e) {
          print("Error parsing response: $e");
          print("Raw response: $responseBody");
        }
      } else {
        print("Error ${response.statusCode}: $responseBody");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
    return null;
  }

  Future<List<Map<String, String>>?> getPlaceDetails(
      List<String> places, String city) async {
    try {
      final body = json.encode({
        "messages": [
          {"role": "system", "content": "You are an assistant."},
          {
            "role": "user",
            "content":
                "Provide detailed information about the following places: ${places.join(", ")} in $city. Include details such as detailed description, Please have the json file in the following format: {'header':'name of place','details':'infos'}. Please only information text string format"
          },
        ],
        "max_tokens": 5000
      });

      final uri = Uri.parse(
          '$apiBase/openai/deployments/$deploymentName/chat/completions?api-version=$apiVersion');

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'api-key': apiKey,
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final rawJsonData = json.decode(response.body);
        final responseContent =
            rawJsonData['choices'][0]['message']['content'] as String;
        final jsonStartIndex = responseContent.indexOf("[");
        final jsonEndIndex = responseContent.lastIndexOf("]");
        final cleanedContent =
            responseContent.substring(jsonStartIndex, jsonEndIndex + 1);
        List<dynamic> cleanedJson = json.decode(cleanedContent);
        List<Map<String, String>> content = cleanedJson
            .map((item) => {
                  'header': item['header'] as String,
                  'details': item['details'] as String,
                })
            .toList();
        return content;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

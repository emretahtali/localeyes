import 'dart:convert';
import 'dart:io';

class PlaceImageService {
  Future<Map<String, String>?> getImgUrlasMap(final String placeName) async {
    final subscriptionKey =
        '312fc4c980dc4738aa90e88ac2910f1d'; // Your Bing API key
    final searchUrl = 'https://api.bing.microsoft.com/v7.0/images/search';

    // API request headers
    final headers = {
      'Ocp-Apim-Subscription-Key': subscriptionKey,
    };

    // Search parameters
    final params = {
      'q': placeName, // Search keyword
      'count': '1', // Number of results (max 150)
      'offset': '0', // Start position
      'mkt': 'en-US', // Market region setting
      'safeSearch': 'Strict', // Safe search filter
      'unique': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    // Construct the query string from parameters
    final uri = Uri.parse(searchUrl).replace(queryParameters: params);

    try {
      // Send the GET request
      final request = await HttpClient().getUrl(uri);
      request.headers.set('Ocp-Apim-Subscription-Key', subscriptionKey);
      final response = await request.close();

      // Check if the response is successful
      if (response.statusCode == HttpStatus.ok) {
        final responseBody = await response.transform(utf8.decoder).join();
        final searchResults = jsonDecode(responseBody);

        // Extract image URLs
        final imageUrls = List<String>.from(
          searchResults['value'].map((img) => img['contentUrl']),
        );

        // return image URL
        return {"placeName": placeName, "imageUrl": imageUrls[0]};
      } else {
        return {
          "placeName": placeName,
          "imageUrl": await response.transform(utf8.decoder).join()
        };
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Map<String, String>>> getUrlsFromPlaceList(
      List<String> places) async {
    final List<Map<String, String>> urls = [];
    final urlData =
        await Future.wait([for (final place in places) getImgUrlasMap(place)]);
    for (var url in urlData) {
      if (url != null) {
        urls.add(url);
      }
    }
    return urls;
  }
}

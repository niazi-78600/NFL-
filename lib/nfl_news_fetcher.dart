// import 'dart:convert';
// import 'package:http/http.dart' as http;
// class NFLNewsFetcher {
//   final String apiUrl =
//       'https://tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com/getNFLNews?topNews=true&fantasyNews=true&recentNews=true&maxItems=20';
//   final String apiKey = '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9';

//   Future<List<Map<String, dynamic>>> fetchNFLNews() async {
//     final response = await http.get(
//       Uri.parse(apiUrl),
//       headers: {
//         'X-RapidAPI-Key': apiKey,
//         'X-RapidAPI-Host':
//             'tank01-nfl-live-in-game-real-time-statistics-nfl.p.rapidapi.com',
//       },
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final body = jsonData['body'] as List<dynamic>;
//       return body.cast<Map<String, dynamic>>();
//     } else {
//       throw Exception('Failed to load news');
//     }
//   }
// }
 import 'package:http/http.dart' as http;

import 'dart:convert';

import 'dart:convert';
import 'package:http/http.dart' as http;

class NFLNewsFetcher {
  static const String _newsAPIUrl =
      'https://site.api.espn.com/apis/site/v2/sports/football/nfl/news?limit=30';

  Future<List<Map<String, dynamic>>> fetchNFLNews() async {
    try {
      final response = await http.get(Uri.parse(_newsAPIUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        // The data might be nested, so extract the necessary list
        final List<dynamic>? articles = data['articles'];

        if (articles != null) {
          // Parse each article
          final List<Map<String, dynamic>> newsList = articles.map((article) {
            final DateTime publishedTime =
                DateTime.parse(article['published']);
            final DateTime now = DateTime.now();
            final Duration difference = now.difference(publishedTime);

            String timeAgo = '';
            if (difference.inMinutes < 60) {
              timeAgo = '${difference.inMinutes} minutes ago';
            } else if (difference.inHours < 24) {
              timeAgo = '${difference.inHours} hours ago';
            } else {
              timeAgo = '${difference.inDays} days ago';
            }

            return {
              'title': article['headline'],
              'description': article['description'],
              'link': article['links']['web']['href'],
              'image': article['images'] != null && article['images'].isNotEmpty
                  ? article['images'][0]['url']
                  : '',
              'published': timeAgo, // Store the formatted time elapsed
            };
          }).toList();

          return newsList;
        } else {
          throw 'No articles found in the response';
        }
      } else {
        throw 'Failed to fetch news';
      }
    } catch (e) {
      throw 'Error fetching news: $e';
    }
  }
}

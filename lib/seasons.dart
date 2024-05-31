import 'dart:convert';
import 'package:http/http.dart' as http;

class SeasonsFetcher {
  Future<List<int>> fetchSeasons() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/seasons'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        return data.cast<int>();
      } else {
        print('Failed to load seasons: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error loading seasons: $error');
      return [];
    }
  }
}

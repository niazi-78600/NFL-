// team_fetcher.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class TeamFetcher {
  Future<List<Map<String, dynamic>>> fetchTeams() async {
    try {
      final response = await http.get(
        Uri.parse('https://api-american-football.p.rapidapi.com/teams?league=1&season=2023'),
        headers: {
          'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
          'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['response'];
        return data.map((team) {
          return {
            'id': team['id'], 
            'name': team['name'],
            'logo': team['logo'],
            'coach': team['coach'],
            'established': team['established']
          };
        }).toList().cast<Map<String, dynamic>>();
      } else {
        print('Failed to load teams: ${response.statusCode}');
        return [];
      }
    } catch (error) {
      print('Error loading teams: $error');
      return [];
    }
  }
}


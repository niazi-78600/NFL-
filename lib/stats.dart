import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class PlayerStatisticsFetcher {
  final String baseUrl = 'https://api-american-football.p.rapidapi.com/teams';
  final String apiKey = '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9'; // Replace with your actual API key
  final int teamId; // Team ID parameter

  PlayerStatisticsFetcher(this.teamId); // Constructor with teamId parameter

  Future<Map<String, dynamic>> fetchTeamStatistics() async {
    final url = Uri.parse('$baseUrl/$teamId/statistics?season=2023');
    final headers = {
      'X-RapidAPI-Key': apiKey,
      'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;

        // Extract relevant data, excluding team names and logos
        if (data['results'] == 1 && data['errors'].isEmpty) {
          // Assuming 'response' contains player data within a list
          final playerData = data['response'].first; // Access the first element

          final statistics = playerData['teams']
              .map((team) => team['groups'])
              .expand((group) => group)
              .map((group) => group['statistics'])
              .expand((stat) => stat)
              .toList();

          // Create a map with filtered data
          final filteredData = {
            'playerId': playerData['player']['id'], // Assuming 'player' exists within playerData
            'playerName': playerData['player']['name'], // Assuming 'player' exists within playerData
            'playerImage': playerData['player']['image'], // Assuming 'player' exists within playerData
            'statistics': statistics.map((stat) => {
              'name': stat['name'],
              'value': stat['value'],
            }).toList(),
          };

          return filteredData;
        } else {
          throw Exception('API error: ${data['errors']}');
        }
      } else {
        throw Exception('Failed to fetch data (Status Code: ${response.statusCode})');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}

class TeamStatsScreen extends StatelessWidget {
  final int teamId; // Replace with the ID of the team to display stats
 const TeamStatsScreen({Key? key, required this.teamId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team Stats (Team ID: $teamId)'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: PlayerStatisticsFetcher(teamId).fetchTeamStatistics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final teamData = snapshot.data!;
          final playerStats = teamData['statistics'] as List<dynamic>;

          // Function to generate table header based on stat names
          List<Widget> getTableHeaders() {
            final headers = <Widget>[Expanded(child: Text('Player Name'))];
            for (final stat in playerStats) {
              headers.add(Expanded(child: Text(stat['name'])));
            }
            return headers;
          }

          // Function to generate table row data for a player
          List<Widget> getPlayerRowData(Map<String, dynamic> playerStat) {
            final data = <Widget>[Expanded(child: Text(playerStat['name']))];
            for (final stat in playerStats) {
              final value = stat['value'];
              data.add(Expanded(child: Text(value ?? '-'))); // Display "-" for missing values
            }
            return data;
          }

          // Generate table headers
          final tableHeaders = Row(children: getTableHeaders());

          // List view to display player stats in table rows
          return ListView.builder(
            itemCount: playerStats.length,
            itemBuilder: (context, index) {
              final playerStat = playerStats[index];
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: getPlayerRowData(playerStat)),
              );
            },
          );
        },
      ),
    );
  }
}
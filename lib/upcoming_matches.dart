import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class UpcomingMatchesFetcher {
//   static Future<List<Map<String, dynamic>>> fetchUpcomingMatches() async {
//     final url = Uri.https(
//       'api-american-football.p.rapidapi.com',
//       '/games',
//       {'league': '1', 'season': '2023'},
//     );

//     final headers = {
//       'X-RapidAPI-Key': '31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9',
//       'X-RapidAPI-Host': 'api-american-football.p.rapidapi.com'
//     };

//     try {
//       final response = await http.get(url, headers: headers);

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['results'] > 0) {
//           final upcomingMatches = data['response'].map<Map<String, dynamic>>((game) {
//             return {
//               'homeTeamName': game['teams']['home']['name'],
//               'homeTeamLogo': game['teams']['home']['logo'],
//               'awayTeamName': game['teams']['away']['name'],
//               'awayTeamLogo': game['teams']['away']['logo'],
//               'date': game['game']['date']['date'],
//               'time': game['game']['date']['time'],
//               'stadium': game['venue'],
//             };
//           }).toList();

//           return upcomingMatches;
//         }
//       } else {
//         print('Failed to load data: ${response.statusCode}');
//         return [];
//       }
//     } catch (error) {
//       print('Error: $error');
//       return [];
//     }
//     return [];
//   }
// }


class UpcomingMatchesFetcher {
  int weekno = 1;

  UpcomingMatchesFetcher({required this.weekno});

  static Future<List<Map<String, dynamic>>> fetchUpcomingMatches(int weekno) async {
    try {
      final url = Uri.https(
        'cdn.espn.com', // The authority
        '/core/nfl/schedule', // The unencoded path
        {'xhr': '1', 'year': '2024', 'week': weekno.toString()} // Query parameters
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final schedule = data['content']['schedule'];

        final List<Map<String, dynamic>> weeklyMatches = [];

        // Iterate through the schedule to find games for the specified week
        for (var dateString in schedule.keys) {
          final games = schedule[dateString]['games'];
          if (games == null || games.isEmpty) {
            continue;
          }

          for (var game in games) {
            final competition = game['competitions'][0];
            if (competition == null || competition['competitors'] == null || competition['competitors'].length < 2) {
              continue;
            }

            final homeTeam = competition['competitors'][0]['team'];
            final awayTeam = competition['competitors'][1]['team'];
            if (homeTeam == null || awayTeam == null) {
              continue;
            }

            final homeTeamName = homeTeam['displayName'] ?? 'Unknown Home Team';
            final homeTeamLogoUrl = homeTeam['logo'] ?? '';
            final awayTeamName = awayTeam['displayName'] ?? 'Unknown Away Team';
            final awayTeamLogoUrl = awayTeam['logo'] ?? '';

            // Extract date and time separately
            final gameDateTime = DateTime.parse(competition['date']);
            final gameDate = gameDateTime.toLocal().toString().split(' ').first; // Extract date only

            // Extract time without milliseconds
            final timeWithoutMillis = gameDateTime.toLocal().toString().split(' ').last.substring(0, 5);  // Extract time and remove last 3 characters (milliseconds)

            weeklyMatches.add({
              'homeTeamName': homeTeamName,
              'homeTeamLogo': homeTeamLogoUrl,
              'awayTeamName': awayTeamName,
              'awayTeamLogo': awayTeamLogoUrl,
              'date': gameDate,  // Separated date
              'time': timeWithoutMillis,  // Separated time without milliseconds
            });
          }
        }

        return weeklyMatches;
      } else {
        throw Exception('Failed to fetch data from ESPN NFL API (Status Code: ${response.statusCode})');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }
}


// class UpcomingMatchesScreen extends StatefulWidget {
//   @override
//   _UpcomingMatchesScreenState createState() => _UpcomingMatchesScreenState();
// }

// class _UpcomingMatchesScreenState extends State<UpcomingMatchesScreen> {
//   late Future<List<Map<String, dynamic>>> _futureMatches;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Upcoming Matches'),
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _futureMatches,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             final matches = snapshot.data;
//             return ListView.builder(
//               itemCount: matches?.length,
//               itemBuilder: (context, index) {
//                 final match = matches?[index];
//                 return ListTile(
//                   title: Text('${match?['homeTeamName']} vs ${match?['awayTeamName']}'),
//                   subtitle: Text('Date: ${match?['date']}'),
//                   leading: Image.network(match?['homeTeamLogo']), // Assuming you have URLs for team logos
//                   trailing: Image.network(match?['awayTeamLogo']), // Assuming you have URLs for team logos
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }


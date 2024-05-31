import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class NFLStandingsScreen extends StatefulWidget {
  @override
  _NFLStandingsScreenState createState() => _NFLStandingsScreenState();
}

class _NFLStandingsScreenState extends State<NFLStandingsScreen> {
  List<Map<String, dynamic>> standings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStandings();
  }

  void fetchStandings() async {
    var url = Uri.parse("https://api-american-football.p.rapidapi.com/standings?league=1&season=2023");

    var headers = {
      "X-RapidAPI-Key": "31b21d43a0msh2e44cebbcccce97p161cafjsnb3aec0c924c9", // Replace with your actual API key
      "X-RapidAPI-Host": "api-american-football.p.rapidapi.com"
    };

    var response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      setState(() {
        standings = parseStandings(response.body);
        isLoading = false;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

 List<Map<String, dynamic>> parseStandings(String responseBody) {
  // 1. Decode the JSON response
  var data = json.decode(responseBody);

  // 2. Initialize an empty list to store parsed standings
  List<Map<String, dynamic>> parsedData = [];

  // 3. Check if the response contains the expected "response" key
  if (data.containsKey('response')) {
    var standingsList = data['response'];

    // 4. Iterate through the standings data and build the parsed list
    for (var item in standingsList) {
      parsedData.add({
        'team': item['team'],
        'conference': item['conference'],
        'division': item['division'],
        'position': item['position'],
        'won': item['won'],
        'lost': item['lost'],
        'ties': item['ties'],
        'points': {
          'for': item['points']['for'],
          'against': item['points']['against'],
          'difference': item['points']['difference']
        }
      });
    }
  } else {
    // Handle parsing failure (optional: log a message or throw an exception)
    print('Failed to find "response" key in the API response.');
  }

  // 5. Return the parsed list of standings data
  return parsedData;
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2), // Light background

      // appBar: AppBar(
      //   backgroundColor: const Color(0xFF002868), // Primary NFL color
      //   title: const Text(
      //     'NFL Standings',
      //     style: TextStyle(
      //       color: Colors.white,
      //       fontSize: 24,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      // ),
body: isLoading
    ? const Center(child: CircularProgressIndicator())
    : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width, // Set width to match screen width
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Section
                // Container(
                //   color: const Color(0xFF002868), // Primary NFL color
                //   padding: const EdgeInsets.all(20),
                //   child: const Center(
                //     child: Text(
                //       'NFL Standings',
                //       style: TextStyle(
                //         color: Colors.white,
                //         fontSize: 24,
                //         fontWeight: FontWeight.bold,
                //       ),
                //     ),
                //   ),
                // ),

                // Standings Table
                SingleChildScrollView( // Wrap with SingleChildScrollView
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    // Remove border for cleaner look
                    decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
                    // Emphasize headers
                    dataTextStyle: const TextStyle(fontWeight: FontWeight.bold),
                    headingTextStyle: const TextStyle(
                      color: Color(0xFF002868), // Primary NFL color
                      fontWeight: FontWeight.bold,
                    ),
                    columns: const [
                      DataColumn(label: Text('Team')),
                      DataColumn(label: Text('Position')),
                      DataColumn(label: Text('Won')),
                      DataColumn(label: Text('Lost')),
                      DataColumn(label: Text('Tied')),
                      DataColumn(label: Text('Points For')),
                      DataColumn(label: Text('Points Against')),
                      DataColumn(label: Text('Point Difference')),
                      DataColumn(label: Text('Conference')),
                      DataColumn(label: Text('Division')),
                    ],
                    rows: standings.map<DataRow>((standing) {
                      return DataRow(
                        cells: [
                          DataCell( Text(standing['team']['name'])),
                          DataCell(Text(standing['position'].toString())),
                          DataCell(Text(standing['won'].toString())),
                          DataCell(Text(standing['lost'].toString())),
                          DataCell(Text(standing['ties'].toString())),
                          DataCell(Text(standing['points']['for'].toString())),
                          DataCell(Text(standing['points']['against'].toString())),
                          DataCell(Text(standing['points']['difference'].toString())),
                           DataCell(Text(standing['conference'])),
                          DataCell(Text(standing['division'])),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),



    );
  }
}

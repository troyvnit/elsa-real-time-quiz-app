import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiz/models/leaderboard_model.dart';

class ApiService {
  static Future<List<LeaderboardModel>> getLeaderboard(String quizId) async {
    final response = await http
        .get(Uri.parse('https://localhost:3000/api/quiz/$quizId/leaderboard'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((item) => LeaderboardModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load leaderboard');
    }
  }
}

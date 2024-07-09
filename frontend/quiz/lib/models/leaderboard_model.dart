class LeaderboardModel {
  final String name;
  final int score;

  LeaderboardModel({required this.name, required this.score});

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      name: json['name'],
      score: json['score'],
    );
  }
}

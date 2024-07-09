import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leaderboard_model.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  LeaderboardScreenState createState() => LeaderboardScreenState();
}

class LeaderboardScreenState extends State<LeaderboardScreen> {
  late String quizId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quizId = ModalRoute.of(context)?.settings.arguments as String;
  }

  Stream<List<LeaderboardModel>> _leaderboardStream() {
    return FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('leaderboard')
        .orderBy('score', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => LeaderboardModel.fromJson(doc.data()))
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: StreamBuilder<List<LeaderboardModel>>(
        stream: _leaderboardStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          }

          var leaderboard = snapshot.data;
          return ListView.builder(
            itemCount: leaderboard!.length,
            itemBuilder: (context, index) {
              var user = leaderboard[index];
              return ListTile(
                title: Text(user.name),
                trailing: Text(user.score.toString()),
              );
            },
          );
        },
      ),
    );
  }
}

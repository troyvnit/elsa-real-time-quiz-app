import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';
import '../services/socket_service.dart';
import '../services/auth_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  QuizScreenState createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen> {
  late Socket socket;
  List<DocumentSnapshot> questions = [];
  Map<String, dynamic> userAnswers = {};
  late String quizId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    quizId = ModalRoute.of(context)?.settings.arguments as String;
    String? userId = Provider.of<AuthService>(context, listen: false).userId;
    socket = SocketService.connect(quizId, userId ?? '');
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('quizzes')
        .doc(quizId)
        .collection('questions')
        .get();

    setState(() {
      questions = snapshot.docs;
    });
  }

  void _submitAnswer(DocumentSnapshot question) {
    String? userId = Provider.of<AuthService>(context, listen: false).userId;
    String answer = userAnswers[question.id] ?? '';
    socket.emit('submitAnswer', {
      'quizId': quizId,
      'userId': userId,
      'question': question.data(),
      'answer': answer,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                var question = questions[index];
                return ListTile(
                  title: Text(question['question']),
                  subtitle: Column(
                    children: question['options'].map<Widget>((option) {
                      return ListTile(
                        title: Text(option),
                        leading: Radio(
                          value: option,
                          groupValue: userAnswers[question.id],
                          onChanged: (value) {
                            setState(() {
                              userAnswers[question.id] = value;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  trailing: ElevatedButton(
                    onPressed: () => _submitAnswer(question),
                    child: const Text('Submit'),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/leaderboard',
            arguments: quizId,
          );
        },
        child: const Icon(Icons.leaderboard),
      ),
    );
  }
}

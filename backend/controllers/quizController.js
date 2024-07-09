const { db } = require('../utils/firebaseAdmin');
const { calculateScore } = require('../utils/scoreCalculator');

const getLeaderboard = async (req, res) => {
  try {
    const quizId = req.params.quizId;
    const leaderboardRef = db.collection('leaderboards').doc(quizId);
    const doc = await leaderboardRef.get();
    if (!doc.exists) {
      res.status(404).send('No leaderboard found');
    } else {
      res.status(200).json(doc.data());
    }
  } catch (error) {
    res.status(500).send(error.toString());
  }
};

const submitAnswer = async (req, res) => {
  try {
    const { quizId } = req.params;
    const { question, userId, answer } = req.body;

    const score = calculateScore(question, answer);

    const quizRef = db.collection('quizzes').doc(quizId);
    const userRef = quizRef.collection('users').doc(userId);

    await userRef.set({ score }, { merge: true });

    res.status(200).send('Answer submitted');
  } catch (error) {
    res.status(500).send(error.toString());
  }
};

module.exports = { getLeaderboard, submitAnswer };

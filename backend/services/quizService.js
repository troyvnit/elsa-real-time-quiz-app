const { db } = require('../utils/firebaseAdmin');
const { calculateScore } = require('../utils/scoreCalculator');

const updateScoreInDatabase = async (quizId, userId, question, answer) => {
  const score = calculateScore(question, answer);

  const quizRef = db.collection('quizzes').doc(quizId);
  const userRef = quizRef.collection('users').doc(userId);

  await userRef.set({ score }, { merge: true });

  return score;
};

module.exports = { updateScoreInDatabase };

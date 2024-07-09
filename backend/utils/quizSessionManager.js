const { db } = require('./firebaseAdmin');

const addUserToSession = async (quizId, userId) => {
  const quizRef = db.collection('quizzes').doc(quizId);
  const sessionRef = quizRef.collection('sessions').doc('active');
  const sessionDoc = await sessionRef.get();

  if (!sessionDoc.exists) {
    await sessionRef.set({ users: [userId] });
  } else {
    await sessionRef.update({
      users: admin.firestore.FieldValue.arrayUnion(userId)
    });
  }

  const userRef = quizRef.collection('users').doc(userId);
  await userRef.set({ joinedAt: new Date() }, { merge: true });
};

const removeUserFromSession = async (quizId, userId) => {
  const quizRef = db.collection('quizzes').doc(quizId);
  const sessionRef = quizRef.collection('sessions').doc('active');

  await sessionRef.update({
    users: admin.firestore.FieldValue.arrayRemove(userId)
  });
};

const getSessionUsers = async (quizId) => {
  const quizRef = db.collection('quizzes').doc(quizId);
  const sessionRef = quizRef.collection('sessions').doc('active');
  const sessionDoc = await sessionRef.get();

  return sessionDoc.exists ? sessionDoc.data().users : [];
};

module.exports = {
  addUserToSession,
  removeUserFromSession,
  getSessionUsers,
};

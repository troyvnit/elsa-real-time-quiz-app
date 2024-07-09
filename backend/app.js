require('dotenv').config();
const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');
const http = require('http');
const socketIo = require('socket.io');
const { db } = require('./utils/firebaseAdmin');
const { calculateScore } = require('./utils/scoreCalculator');
const { addUserToSession, removeUserFromSession, getSessionUsers } = require('./utils/quizSessionManager');
const quizRouter = require('./routes/quiz');

const app = express();

// Middleware
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Routes
app.use('/api/quiz', quizRouter);

// Create HTTP server and setup WebSocket
const server = http.createServer(app);
const io = socketIo(server);

io.on('connection', (socket) => {
  console.log('New client connected');

  socket.on('joinQuiz', async (data) => {
    const { quizId, userId } = data;

    try {
      await addUserToSession(quizId, userId);
      const users = await getSessionUsers(quizId);
      io.to(quizId).emit('userJoined', users);
      socket.join(quizId);
    } catch (error) {
      console.error(error);
      socket.emit('error', 'Error joining quiz');
    }
  });

  socket.on('submitAnswer', async (data) => {
    const { quizId, question, userId, answer } = data;

    try {
      const score = calculateScore(question, answer);

      const quizRef = db.collection('quizzes').doc(quizId);
      const userRef = quizRef.collection('users').doc(userId);

      await userRef.set({ score }, { merge: true });

      const leaderboardSnapshot = await quizRef.collection('users').orderBy('score', 'desc').get();
      const leaderboard = leaderboardSnapshot.docs.map(doc => doc.data());

      io.to(quizId).emit('leaderboardUpdate', leaderboard);
    } catch (error) {
      console.error(error);
    }
  });

  socket.on('disconnect', () => {
    console.log('Client disconnected');
  });
});

module.exports = { app, server };

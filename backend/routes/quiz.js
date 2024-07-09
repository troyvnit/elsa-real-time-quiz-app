const express = require('express');
const router = express.Router();
const { getLeaderboard, submitAnswer } = require('../controllers/quizController');

router.get('/:quizId/leaderboard', getLeaderboard);
router.post('/:quizId/submitAnswer', submitAnswer);

module.exports = router;

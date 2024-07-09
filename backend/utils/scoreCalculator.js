const calculateScore = (question, userAnswer) => {
    if (question.type === 'single') {
      return question.correctAnswer === userAnswer ? 10 : 0;
    } else if (question.type === 'multiple') {
      const correctAnswers = question.correctAnswers;
      const userAnswers = userAnswer;
      let score = 0;
  
      correctAnswers.forEach((answer) => {
        if (userAnswers.includes(answer)) {
          score += 10;
        }
      });
  
      return score;
    }
    return 0;
  };
  
  module.exports = { calculateScore };
  
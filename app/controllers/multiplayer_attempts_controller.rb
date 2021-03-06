class MultiplayerAttemptsController < ApplicationController
  def new
    @quiz = Quiz.find params[:quiz_id]
  end

  def check_answer
    answer_id = params[:id]
    question_id = params[:question_id]

    question = Question.find question_id
    answer = question.answers.find answer_id
    WebsocketRails[:answers].trigger 'new', {correct: answer.correctness}
    render json: {correct: answer.correctness}
  end
end

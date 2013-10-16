class AttemptsController < ApplicationController

  def new
    @quiz = Quiz.find params[:quiz_id]
  end

  def create
    @quiz = Quiz.find params[:quiz_id]
    answer_ids = params[:answer_ids].values
    scorer = Scorer.new(@quiz)

    percent = (scorer.total(answer_ids) / @quiz.questions.count.to_f) * 100
    render text: "#{percent.to_i}%"
  end

end

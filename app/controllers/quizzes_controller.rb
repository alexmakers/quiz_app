class QuizzesController < ApplicationController

  before_filter :authenticate_user!, only: [:new, :create]

  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
    # redirect_to '/'
  end

  def new
    @quiz = Quiz.new
    @quiz.populate(num_of_questions: 5, num_of_answers: 4)
  end

  def create
    @quiz = Quiz.new quiz_params

    if @quiz.save
      WebsocketRails[:quizzes].trigger 'new', @quiz
      redirect_to @quiz
    else
      render 'new'
    end
  end

  def edit
    @quiz = Quiz.find params[:id]
  end

  def update
    @quiz = Quiz.find params[:id]
    if @quiz.update quiz_params
      redirect_to @quiz
    else
      render 'edit'
    end
  end

  private

  def quiz_params
    params.require(:quiz)
          .permit :title, questions_attributes: 
                            [:id, :query, answers_attributes: 
                                [:id, :response, :correctness]]
  end

end

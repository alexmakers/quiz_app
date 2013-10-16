class Scorer

  def initialize(quiz)
    @quiz = quiz
  end

  def total(answer_ids)
    answer_ids.map! &:to_i
    (@quiz.correct_answer_ids & answer_ids).length
  end

end
class Question < ActiveRecord::Base

  belongs_to :quiz
  has_many :answers

  accepts_nested_attributes_for :answers, reject_if: ->(a) { a[:response].blank? }

  def populate_answers(num_of_answers)
    num_of_answers.times { answers.build }
  end

  def correct_answer
    answers.find_by_correctness(true)
  end

end
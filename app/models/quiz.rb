class Quiz < ActiveRecord::Base

  has_many :questions
  accepts_nested_attributes_for :questions, reject_if: ->(q) { q[:query].blank? }

  validates :title, presence: true

  def populate(num_of_questions: 0, num_of_answers: 0)
    num_of_questions.times do
      question = questions.build
      question.populate_answers(num_of_answers)
    end
  end

  def correct_answer_ids
    questions.map { |q| q.correct_answer.id }
  end

end
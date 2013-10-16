require 'spec_helper'

describe 'taking a quiz' do

  before do
    @quiz = create(:quiz, questions: [create(:question), create(:question)])
  end

  it 'should show me the score' do
    visit new_quiz_attempt_path(@quiz)

    choose 'Correct1'
    choose 'Incorrect2'

    click_button 'Submit'
    expect(page).to have_content '50%'
  end
  
end
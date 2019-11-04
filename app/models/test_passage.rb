class TestPassage < ApplicationRecord
  belongs_to :test
  belongs_to :user
  belongs_to :current_question, class_name: 'Question', optional: true

  before_validation :before_validation_set_question, on: %i[create update]

  before_update :before_update_next_question

  SUCCESS_SCORE = 85

  def test_passed?
    success_percentage >= SUCCESS_SCORE
  end

  def completed?
    current_question.nil?
  end

  def accept!(answer_ids)
    if correct_answer?(answer_ids)
      self.correct_questions += 1
    end
    save!
  end

  def success_percentage
    (correct_questions / total_questions.to_f) * 100
  end

  def total_questions
    test.questions.count
  end


  private

  def before_validation_set_question
    if current_question.nil? && test.present?
      set_first_question
    else
      set_next_question
    end
  end

  def set_first_question
    self.current_question = test.questions.first
  end

  def set_next_question
    self.current_question = next_question
  end

  def correct_answer?(answer_ids)
    correct_answers_count = correct_answers.count

    (correct_answers_count == correct_answers.where(id: answer_ids).count) &&
        correct_answers_count == answer_ids.count
  end

  def correct_answers
    current_question.answers.correct
  end

  def next_question
    remaining_questions.first
  end

  def remaining_questions
    test.questions.order(:id).where('id > ?', current_question.id)
  end
end

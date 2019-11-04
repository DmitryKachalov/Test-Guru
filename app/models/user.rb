class User < ApplicationRecord
  has_many :test_passages, dependent: :nullify
  has_many :tests, through: :test_passages

  has_many :tests_created, class_name: 'Test', foreign_key: :author_id

  validates :name, :email, :role, presence: true

  def by_level(level)
    tests.level(level)
  end

  def test_passage(test)
    test_passages.order(id: :desc).find_by(test_id: test.id)
  end
end

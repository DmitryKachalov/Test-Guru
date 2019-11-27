class User < ApplicationRecord

  has_many :test_passages, dependent: :nullify
  has_many :tests, through: :test_passages
  has_many :tests_created, class_name: 'Test', foreign_key: :author_id
  has_many :gists
  has_many :achievements
  has_many :badges, through: :achievements

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable,
         :confirmable

  def by_level(level)
    tests.level(level)
  end

  def test_passage(test)
    test_passages.order(id: :desc).find_by(test_id: test.id)
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def admin?
    kind_of?(Admin)
  end
end

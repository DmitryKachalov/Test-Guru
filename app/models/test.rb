class Test < ApplicationRecord
  belongs_to :category
  has_many :questions

  has_many :test_passages
  has_many :users, through: :test_passages

  belongs_to :author, class_name: 'User'

  validates :title, presence: true,
                    uniqueness: true
  validates :level, numericality: { only_integer: true }, allow_nil: true
  validate :validate_max_level, on: :create

  scope :easy,    -> { where(level: 0..1) }
  scope :medium,  -> { where(level: 2..4) }
  scope :hard,    -> { where(level: 5..Float::INFINITY) }

  def self.sort_by_category(category_title)
    joins(:category)
        .where(categories: { title: category_title })
        .order(title: :desc)
        .pluck(:title)
  end

  private

  def validate_max_level
    errors.add(:level) if level.to_i > 10
  end
end

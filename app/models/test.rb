class Test < ApplicationRecord
  belongs_to :category
  has_many :questions, dependent: :destroy

  has_many :test_passages, dependent: :destroy
  has_many :users, through: :test_passages

  belongs_to :author, class_name: 'User'

  validates :title, presence: true,
                    uniqueness: { scope: :level,
                                  message: 'Title and Level must be unique' }
  validates :level, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :validate_max_level, on: :create

  default_scope { order(title: :desc) }

  scope :level, ->(level) { where(level: level) }
  scope :by_category, ->(title_category) { joins(:category).where(categories: { title: title_category }) }
  scope :easy,    -> { level(0..1) }
  scope :medium,  -> { level(2..4) }
  scope :hard,    -> { level(5..Float::INFINITY) }

  def self.sort_by_category(category_title)
    by_category(category_title)
        .pluck(:title)
  end

  private

  def validate_max_level
    errors.add(:level) if level.to_i > 10
  end
end

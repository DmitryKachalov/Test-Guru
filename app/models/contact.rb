class Contact
  include ActiveModel::Model

  validates_format_of :email, :with => /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates :name, :body, :email, presence: true

  attr_accessor :name, :body, :email, :admin

  def initialize(attributes = { name=>"", body=>"", email=>"" })
    @name = attributes["name"]
    @body = attributes["body"]
    @email = attributes["email"]
    @admin = User.find_by(type: 'Admin')
  end

end

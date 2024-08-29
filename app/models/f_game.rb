class Game
  include ActiveModel::Validations

  attr_reader :username, :id

  validates :username, presence: true

  def initialize(attributes = {})
    @username = attributes[:username]
    @id = nil
  end

  def save
    if valid?
      @id = (1..1000).to_a.sample
      true
    else
      false
    end
  end
end

class Player < ApplicationRecord
  has_many :game_players, dependent: :destroy
  has_many :games, through: :game_players

  before_validation :set_default_name

  validates :username, presence: true
  validates :username, uniqueness: true
  validates :username, format: { message: "only allows letters, numbers, spaces, and dashes", with: /\A[a-zA-Z0-9\s-]+\z/ }

  # @param [Boolean] join_game - whether to join the game after creating it, default is true
  def create_game(join_game = true)
    games.create
  end

  private

  def set_default_name
    self.username ||= "#{Faker::Games::Minecraft.mob} -- generated at #{Time.now.to_i}"
  end
end

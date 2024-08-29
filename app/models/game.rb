class Game < ApplicationRecord
  MAX_PLAYERS = 4

  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  before_validation :set_default_name

  enum :status, {
    waiting: 0,
    playing: 1,
    finished: 2
  }, prefix: true

  def full?
    players.length >= MAX_PLAYERS
  end

  private

  def set_default_name
    self.name ||= "#{Faker::Games::Minecraft.biome}"
  end
end

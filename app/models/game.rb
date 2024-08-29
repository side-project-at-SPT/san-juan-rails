class Game < ApplicationRecord
  has_many :game_players, dependent: :destroy
  has_many :players, through: :game_players

  before_validation :set_default_name

  validate :player_less_or_equal_to_four

  enum :status, {
    waiting: 0,
    playing: 1,
    finished: 2
  }, prefix: true

  private

  def set_default_name
    self.name ||= "#{Faker::Games::Minecraft.biome}"
  end

  def player_less_or_equal_to_four
    if players.length > 4
      errors.add(:players, "must be less than or equal to four")
    end
  end
end

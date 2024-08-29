class GamePlayer < ApplicationRecord
  belongs_to :game
  belongs_to :player

  validates :game_id, uniqueness: { scope: :player_id, message: "Player already joined game" }

  validate :game_player_number_constraint, on: :create

  def ready!
    update!(ready: true)
  end

  private

  def game_player_number_constraint
    if game.full?
      errors.add(:game, "is full. (max players: #{Game::MAX_PLAYERS})")
    end
  end
end

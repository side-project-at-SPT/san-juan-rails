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

  def setup!
    # TODO: Implement game setup
    # - Initialize the game seed
    self.game_config[:seed] ||= Random.new_seed
    srand(self.game_config[:seed])
    # - Determine the player order
    self.game_config[:order] ||= player_ids.sort.shuffle
    self.game_data[:players] = player_ids.map { |id| { id: id, score: 0 } }
    self.game_data[:current_player] = game_data[:players][0][:id]
    # - Prepare the trading house tiles
    # - Prepare a new deck of cards
    # - Shuffle the deck
    # - Deal 4 cards to each player
    # - Variations: second player gets 5 cards, third player gets 6 cards,
    #               fourth player gets 7 cards, then discard to 4 cards.
    # - Deal 1 indigo plant to each player
    # - Prepare the role cards
    self.game_data[:available_role_cards] = {
      builder: true,
      producer: true,
      trader: true,
      councillor: true,
      prospector: true
    }
    # - Set the game status to 'playing'
    self.status = :playing
    save!
  end


  def player_select_role_card(player, role_card)
    unless status_playing?
      errors.add(:game, "is not playing")
      return
    end
    unless player_ids.include?(player.id)
      errors.add(:player, "is not in this game")
      return
    end
    unless game_data["available_role_cards"][role_card.to_s]
      errors.add(:role_card, "is not available")
      return
    end

    self.game_data["available_role_cards"][role_card.to_s] = false
    self.game_data["players"].find { |p| p["id"] == player.id }["role_card"] = role_card
    save!
  end

  private

  def set_default_name
    self.name ||= "#{Faker::Games::Minecraft.biome}"
  end
end

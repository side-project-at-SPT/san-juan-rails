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
    self.game_data[:players] = game_config[:order].map { |id| { id: id, score: 0 } }
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

  # @param [Player] player
  # @param [String] role_card one of 'builder', 'producer', 'trader', 'councillor', 'prospector'
  def player_select_role_card(player, role_card)
    errors.add(:game, "is not playing") and return unless status_playing?
    errors.add(:player, "is not in this game") and return unless player_ids.include?(player.id)
    errors.add(:role_card, "is not available") and return unless game_data["available_role_cards"][role_card.to_s]

    self.game_data["available_role_cards"][role_card.to_s] = false
    self.game_data["players"].find { |p| p["id"] == player.id }["role_card"] = role_card
    save
  end

  def begin_phase!(player, role_card)
    self.game_data["current_phase"] = role_card
    save!

    # TODO: Implement phase logic
    def flag_phase_action_not_implemented? = true

    if flag_phase_action_not_implemented?
      Rails.logger.warn { "#{game_data["current_phase"]} is beginning, but all actions are not implemented" }
      Rails.logger.warn { "END PHASE DIRECTLY" }
      end_phase!
    else
      notify_phase_begin!
    end
  end

  private

  def set_default_name
    self.name ||= "#{Faker::Games::Minecraft.biome}"
  end

  def end_phase!
    # TODO: Implement phase logic
    if game_is_over?
      game_over!
    else
      if game_data["players"].all? { |p| p["role_card"].present? }
        next_round!
      else
        next_phase!
      end
    end
  end

  def game_is_over?
    Rails.logger.info("Checking game over condition...")
    Rails.logger.warn("Return true since Game over condition is not implemented")
    true

    # TODO: Implement game over condition
  end

  def game_over!
    self.status = :finished
    self.game_data["winner"] = calculate_winner(game_data)
    save!
  end

  def calculate_winner(game_data)
    # TODO: Implement winner calculation
    game_data["players"].select { |p| p["role_card"] == "prospector" }[0]["id"]
  end

  def notify_phase_begin!
    Rails.logger.warn { "phase actions are not implemented" }
    # case game_data["current_phase"]
    # when "builder"
    #   # - Player selects a building to build
    #   # - Player pays the cost
    #   # - Player builds the building
    #   # - Player gains the building's power
    # when "producer"
    #   # - Player produces goods
    #   # - Player gains the goods
    # when "trader"
    #   # - Player trades goods
    #   # - Player gains gold
    # when "councillor"
    #   # - Player draws cards
    #   # - Player discards cards
    # when "prospector"
    #   # - Player gains gold
    # end
  end

  def decide_next_turn
    # TODO: Implement turn logic
    # - Read the turn counter
    turn_counter = game_data["turn_counter"]
    Rails.logger.info("Current player is #{game_data['players'][turn_counter]['id']}")
    Rails.logger.info("Deciding next turn...")
    # add 1 as current player has taken their turn
    turn_counter += 1
    # - Determine the next player
    #   - If turn counter is reached this game's player count
    #     - reset turn counter to 0
    #     - current phase is over, call decide_next_phase
    #   - Else, it is the next player's turn
    if turn_counter >= player_ids.length
      turn_counter = 0
      self.game_data["turn_counter"] = turn_counter
      Rails.logger.info(">>Deciding next turn done")
      Rails.logger.info("Current phase is over")
      decide_next_phase
    else
      Rails.logger.info(">>Deciding next turn done")
      Rails.logger.info("Next player is #{game_data['players'][turn_counter]['id']}")
      self.game_data["turn_counter"] = turn_counter
    end
  end

  def decide_next_phase
  end
end

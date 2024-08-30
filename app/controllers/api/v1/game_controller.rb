class Api::V1::GameController < ApplicationController
  before_action :find_player, only: [ :create, :join_game, :set_player_ready, :select_role_card ]
  before_action :find_game, only: [ :join_game, :set_player_ready, :select_role_card ]
  before_action :find_game_player, only: [ :set_player_ready ]

  def create
    @game = @player.create_game
    if @game.present?
      render json: {
        message: "Game created",
        game_id: @game.id
      }, status: :created
    else
      render json: {
        message: @game.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  def join_game
    errors = @game.game_players.find_or_create_by(player_id: @player.id).errors
    if errors.any?
      render json: {
        message: errors.full_messages
      }, status: :unprocessable_entity
    else
      head :no_content
    end
  end

  def set_player_ready
    @game_player.ready!
    head :no_content
  end

  def select_role_card
    @game.player_select_role_card(@player, params[:role_card])
    if @game.errors.any?
      return render json: {
        message: @game.errors.full_messages
      }, status: :unprocessable_entity
    end

    @game.begin_phase!(@player, params[:role_card])

    head :no_content
  end

  private

  def game_params
    params.require(:game).permit(:username)
  end

  def find_game
    @game = Game.find(params[:id])
  end

  def find_player
    @player = Player.find_or_create_by(username: params[:username])
  end

  def find_game_player
    if @game.player_ids.exclude?(@player.id)
      render json: {
        message: "You are not in this game"
      }, status: :unprocessable_entity
      nil
    else
      @game_player = GamePlayer.find([ @game.id, @player.id ])
    end
  end
end

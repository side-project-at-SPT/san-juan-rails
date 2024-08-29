class Api::V1::GameController < ApplicationController
  before_action :find_player, only: [ :create, :join_game ]
  before_action :find_game, only: [ :join_game ]

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
end

class Api::V1::GameController < ApplicationController
  def create
    find_player
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

  private

  def game_params
    params.require(:game).permit(:username)
  end

  def find_player
    @player = Player.find_or_create_by(username: params[:username])
  end
end

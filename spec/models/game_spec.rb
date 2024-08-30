require 'rails_helper'

RSpec.describe Game, type: :model do
  context 'when game is setup' do
    let(:game) { Game.create(name: 'game1') }

    before do
      4.times { |i| game.players << Player.create(username: "player#{i}") }
      game.setup!
    end

    context 'when game over condition is met' do
      it 'game should finish' do
        expect(game.status).to eq('playing')

        current_player = game.players.find(game.game_data['current_player'])
        game.player_select_role_card(current_player, 'prospector')
        game.begin_phase!(current_player, 'prospector')

        expect(game.status).to eq('finished')
        expect(game.game_data['winner']).to be_present
      end
    end
  end
end

class CreateGamePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :game_players, primary_key: %i[game_id player_id] do |t|
      t.references :game, null: false, foreign_key: true
      t.references :player, null: false, foreign_key: true
      t.boolean :ready

      t.timestamps
    end
  end
end

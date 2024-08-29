class CreateGames < ActiveRecord::Migration[7.2]
  def change
    create_table :games do |t|
      t.string :name
      t.integer :status, default: 0 # 0: waiting, 1: playing, 2: finished
      t.json :game_config, default: {}
      t.json :game_data, default: {}

      t.timestamps
    end
  end
end

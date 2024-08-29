class CreatePlayers < ActiveRecord::Migration[7.2]
  def change
    create_table :players do |t|
      t.string :username, null: false
      t.integer :role, default: 0 # 0: visitor, 1: normal, 9: admin

      t.timestamps
    end
    add_index :players, :username, unique: true
  end
end

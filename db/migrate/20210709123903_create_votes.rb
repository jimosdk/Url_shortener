class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.integer :voter_id,null:false
      t.integer :url_id,null:false
      t.integer :score,null:false
      t.timestamps
    end

    add_index :votes,[:voter_id,:url_id],unique: true
  end
end

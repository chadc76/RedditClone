class AddColToVote < ActiveRecord::Migration[6.1]
  def change
    add_column :votes, :user_id, :integer, null: false
    add_index :votes, [:user_id, :votable_type, :votable_id], unique: true
  end
end

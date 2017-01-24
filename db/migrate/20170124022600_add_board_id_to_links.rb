class AddBoardIdToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :board_id, :integer
  end
end

class AddTimestampToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :timestamp, :integer
  end
end

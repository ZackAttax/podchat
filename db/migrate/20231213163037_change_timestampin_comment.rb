class ChangeTimestampinComment < ActiveRecord::Migration[7.0]
  def change
    change_column :comments, :timestamp, :bigint
  end
end

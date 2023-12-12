class AddSpotifyUidColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :spotify_uid, :string
  end
end

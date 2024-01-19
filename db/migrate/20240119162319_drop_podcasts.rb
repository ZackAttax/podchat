class DropPodcasts < ActiveRecord::Migration[7.0]
  def change
    drop_table :podcasts do |t|
      t.string :title
      t.text :description
      t.string :image
      t.timestamps
    end
  end
end

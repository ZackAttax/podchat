class CreatePodcasts < ActiveRecord::Migration[7.0]
  def change
    create_table :podcasts do |t|
      t.string :title
      t.text :description
      t.string :image

      t.timestamps
    end
    add_index :podcasts, :title, unique: true
  end
end

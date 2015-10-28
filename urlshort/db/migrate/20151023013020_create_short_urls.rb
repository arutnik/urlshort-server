class CreateShortUrls < ActiveRecord::Migration
  def change
    create_table :short_urls do |t|
      t.string :original_url
      t.string :url_id 
      t.timestamps null: false
    end
  end
end

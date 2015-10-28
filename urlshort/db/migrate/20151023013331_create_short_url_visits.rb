class CreateShortUrlVisits < ActiveRecord::Migration
  def change
    create_table :short_url_visits do |t|
      t.string :visitor_ip
      t.references :short_url
      t.timestamps null: false
    end
  end
end

class ShortUrl < ActiveRecord::Base
  has_many :short_url_visits
end

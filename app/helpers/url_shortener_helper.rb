module UrlShortenerHelper

  ##Establish the digit values
  @@base64_digits = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a << '_' << '-'

  ##
  # => Converts an integer +integerId+ into
  # a short string base64-like representation.
  ##
  def self.getShortId(integerId)

    CustomRadix.custom_radix( integerId, @@base64_digits )

  end

end

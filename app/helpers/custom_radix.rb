module CustomRadix
  # generate string representation of integer, using digits from custom alphabet
  # [val] a value which can be cast to integer
  # [digits] a string or array of strings representing the custom digits
  def self.custom_radix val, digits

    digits = digits.to_a unless digits.respond_to? :[]
    radix = digits.length
    raise ArgumentError, "radix must have at least two digits" if radix < 2

    i = val.to_i
    out = []
    begin
      rem = i % radix
      i /= radix
      out << digits[rem..rem]
    end until i == 0

    out.reverse.join
  end

  # can be used as mixin, eg class Integer; include CustomRadix; end
  # 32.custom_radix('abcd') => "caa" (200 base 4) equiv to 32.to_s(4).tr('0123','abcd')
  def custom_radix digits
    CustomRadix.custom_radix self, digits
  end
end

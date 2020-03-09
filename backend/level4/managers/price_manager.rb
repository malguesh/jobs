class PriceManager
  require 'active_support/core_ext/enumerable'

  # Calculate price value among time according to rental and car infos
  def self.time_price(rental, price_per_day)
    # Percentage conditions
    (1..rental.rental_days).sum do |day|
      if day == 1
        price_per_day
      elsif (2..4).cover?(day)
        price_per_day * 0.9
      elsif (5..10).cover?(day)
        price_per_day * 0.7
      else
        price_per_day * 0.5
      end
    end

  end

  # Calculate price value among distance according to rental and car infos
  def self.distance_price(rental, price_per_km)
    rental.distance * price_per_km
  end
end

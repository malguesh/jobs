class PriceManager

  # Calculate price value among time according to rental and car infos
  def self.time_price(rental, price_per_day)

    rental.rental_days * price_per_day
  end

  # Calculate price value among distance according to rental and car infos
  def self.distance_price(rental, price_per_km)
    rental.distance * price_per_km
  end
end

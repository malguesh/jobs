require 'json'
require 'date'

require_relative 'managers/json_files_manager'
require_relative 'managers/price_manager'
require_relative 'models/rental'

# Calculate rentals prices
def rentals_prices
  rentals = JsonFilesManager.rentals
  cars = JsonFilesManager.cars

  return if rentals.nil? || cars.nil?

  output_rentals = []
  rentals.each do |rental|
    car = cars.find { |c| c.id == rental.car_id }
    price_per_day = car.price_per_day
    price_per_km = car.price_per_km

    price = PriceManager.time_price(rental, price_per_day).to_i + PriceManager.distance_price(rental, price_per_km).to_i

    output_rentals << Rental.new(id: rental.id, price: price).to_h
  end

  { 'rentals': output_rentals }
end

# Generate json output for rental prices
JsonFilesManager.generate_json_output(rentals_prices)

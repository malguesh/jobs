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
    price = PriceManager.time_price(rental, car.price_per_day).to_i + PriceManager.distance_price(rental, car.price_per_km).to_i

    # Calculate prices with commission
    commission = (price * 0.3).to_i
    insurance_fee = commission / 2
    assistance_fee = rental.rental_days * 100
    drivy_fee = commission - insurance_fee - assistance_fee

    output_rentals << Rental.new(
      id: rental.id,
      price: price,
      insurance_fee: insurance_fee,
      assistance_fee: assistance_fee,
      drivy_fee: drivy_fee
    ).to_h
  end

  { 'rentals': output_rentals }
end

# Generate json output for rental prices
JsonFilesManager.generate_json_output(rentals_prices)

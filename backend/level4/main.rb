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

    # Calculate prices of different users with commission
    commission = (price * 0.3).to_i
    driver = { who: 'driver', type: 'debit', amount: price }
    owner = { who: 'owner', type: 'credit', amount: price - commission }
    insurance_fee = { who: 'insurance', type: 'credit', amount: commission / 2 }
    assistance_fee = { who: 'assistance', type: 'credit', amount: rental.rental_days * 100 }
    drivy_fee = {
      who: 'drivy',
      type: 'credit',
      amount: commission - insurance_fee[:amount] - assistance_fee[:amount]
    }

    # TODO: use Rental model...
    hashes = []
    hashes << driver << owner << insurance_fee << assistance_fee << drivy_fee

    output_rentals << {
      id: rental.id,
      actions: hashes
    }
  end

  { rentals: output_rentals }
end

# Generate json output for rental prices
JsonFilesManager.generate_json_output(rentals_prices)

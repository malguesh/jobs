class JsonFilesManager
  require_relative '../models/car'
  require_relative '../models/rental'

  # Get data from json input
  def self.get_input_data(file)
    file = File.read(file)

    JSON.parse(file)
  end

  def self.generate_json_output(json_data)
    file = File.open('./data/output.json', 'w')

    file.write(JSON.pretty_generate(json_data))
  end

  # -- Specifically get cars and rentals from input json file

  # Define cars among json input
  def self.cars
    data = get_input_data('./data/input.json')

    cars = []
    data['cars'].each do |c|
      cars << Car.new(c['id'], c['price_per_day'], c['price_per_km'])
    end

    cars
  end

  # Define rentals among json input
  def self.rentals
    data = get_input_data('./data/input.json')

    rentals = []
    data['rentals'].each do |r|
      rentals << Rental.new(
        id: r['id'],
        car_id: r['car_id'],
        start_date: r['start_date'],
        end_date: r['end_date'],
        distance: r['distance']
      )
    end

    rentals
  end
end

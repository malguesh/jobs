class Rental
  def initialize(params = {})
    @id = params[:id]
    @car_id = params[:car_id]
    @start_date = params[:start_date]
    @end_date = params[:end_date]
    @distance = params[:distance]
    @price = params[:price]
    @insurance_fee = params[:insurance_fee]
    @assistance_fee = params[:assistance_fee]
    @drivy_fee = params[:drivy_fee]
  end

  attr_reader :id, :car_id, :start_date, :end_date, :distance, :price
  attr_reader :insurance_fee, :assistance_fee, :drivy_fee

  def to_h
    {
      id: id,
      price: price,
      commission: {
        insurance_fee: insurance_fee,
        assistance_fee: assistance_fee,
        drivy_fee: drivy_fee
      }
    }
  end

  # Calculate number of renting days
  def rental_days
    # mjd returns value of date in number
    days_between = Date.parse(end_date).mjd - Date.parse(start_date).mjd

    days_between + 1
  end
end

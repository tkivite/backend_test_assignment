class CarsSelectionController < ApplicationController
  include Pagy::Backend
  before_action only: %i[show]

  # GET /user_car_selection
  def index
    @user = User.find_by(id: params["userid"])
    @cars = Car.where(nil)
    if (params["query"].present? || params["price_min"].present? || params["price_max"].present?)
      @cars = @cars.filter_with_brand(params["query"]) if params["query"].present?
      @cars = @cars.filter_with_price_min(params["price_min"]) if params["price_min"].present? && valid_price?(params["price_min"])
      @cars = @cars.filter_with_price_max(params["price_max"]) if params["price_max"].present? && valid_price?(params["price_max"])
      @pagy, @records = pagy(@cars, page: params["page"])
    else
      @cars = Car.weighted_search(@user) + Car.user_ai_recommendations(@user) + Car.user_unranked_cars(@user)
      @pagy_a, @records = pagy_array(@cars, page: params["page"])
    end

    @records = build_response(@records, @user)
    render json: { data: @records }
  end

  private

  def valid_price?(price)
    price.is_a?(Numeric)
  end

  def build_response(cars, user)
    response = []
    cars.each do |car|
      item = {
        id: car.id,
        brand: {
          id: car.brand.id,
          name: car.brand.name,
        },
        price: car.price,
        rank_score: car.user_rank_score(user),
        model: car.model,
        label: car.user_label(user),
      }
      response << item
    end
    response
  end
end

class CarsSelectionController < ApplicationController
  include Pagy::Backend
  before_action only: %i[show]

  # GET /user_car_selection
  def index
    @user = User.find_by(id: params["userid"])
    @cars = Car.where(nil)

    if (all_params_blank?(params)) # "Fetching cars based on user stored preferences"
      user_car_match_query = UserCarMatchQuery.new(@cars, @user)
      @cars = user_car_match_query.perfect_match + user_car_match_query.good_match +
              user_car_match_query.user_recomendation + user_car_match_query.no_match

      @pagy_a, @records = pagy_array(@cars, page: params["page"])
    else # "Fetching cars based on supplied filters"
      @pagy, @records = pagy(cars_with_query_filters(@cars), page: params["page"])
    end

    @records = build_response(@records, @user)
    render json: { data: @records }
  end

  private

  def all_params_blank?(params)
    params["query"].blank? && params["price_min"].blank? && params["price_max"].blank?
  end

  def cars_with_query_filters(cars)
    cars = cars.filter_with_brand(params["query"]) if params["query"].present?
    cars = cars.filter_with_price_min(params["price_min"]) if params["price_min"].present? && valid_price?(params["price_min"])
    cars = cars.filter_with_price_max(params["price_max"]) if params["price_max"].present? && valid_price?(params["price_max"])
  end

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
        rank_score: user.user_car_rank(car),
        model: car.model,
        label: user.user_car_label(car),
      }
      response << item
    end
    response
  end
end

class CronTask
  require "rest-client"
  include Sidekiq::Worker

  def perform
    base_url = "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json?user_id=1"
    #   api_response = RestClient.get(url, headers={})
    begin
      User.all.each do |user|
        api_response = RestClient::Request.execute(method: :get, url: base_url + "?user_id = #{user.id}",
                                                   timeout: 30)
        if (api_response.code == '200')
          user_recommendation = JSON.parse(api_response.body)
          p user_recommendation["car_id"]
          p user_recommendation[:car_id]
          recomendation = UserCarRecomendation.where(user_id: user.id, car_id: user_recommendation["car_id"].to_i).first_or_initialize
          recomendation.rank_score = user_recommendation["rank_score"]
          recomendation.save!
        end
      rescue => e
        p e.inspect
      end
    end
  end
end

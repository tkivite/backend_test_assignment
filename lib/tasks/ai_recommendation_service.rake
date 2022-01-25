namespace :ai_recommendation_service do
  desc "Fetch records from ai recommendation service"
  task fetch_records: :environment do
    base_url = "https://bravado-images-production.s3.amazonaws.com/recomended_cars.json?user_id=1"
    #   api_response = RestClient.get(url, headers={})
    begin
      p "Exec tasks"
      # p User.all
      User.all.each do |user|
        api_response = RestClient::Request.execute(method: :get, url: base_url + "?user_id = #{user.id}",
                                                   timeout: 30)

        if (api_response.code == 200)
          body = api_response.body
          data = JSON.parse body

          data.each_with_index do |rec|
            p rec["car_id"]
            rec["rank_score"]
            recomendation = UserCarRecomendation.where(user_id: user.id, car_id: rec["car_id"]).first_or_initialize
            recomendation.rank_score = rec["rank_score"]
            recomendation.save!
          end
        end
      rescue => e
        p e.inspect
      end
    end
  end
end

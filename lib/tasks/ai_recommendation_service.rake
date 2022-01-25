namespace :ai_recommendation_service do
  desc "Fetch records from ai recommendation service"
  task fetch_records: :environment do
    base_url = ENV["EXTERNAL_RECOMENDATION_SERVICE"]

    begin
      User.all.each do |user|
        Rails.logger.info "Calling endpoint: #{base_url}?user_id = #{user.id}"
        api_response = RestClient::Request.execute(method: :get, url: base_url + "?user_id = #{user.id}",
                                                   timeout: 30)

        if (api_response.code == 200)
          body = api_response.body
          data = JSON.parse body

          data.each_with_index do |rec|
            Rails.logger.info "Found a record "
            Rails.logger.info "----------------------------------------------------------------"
            Rails.logger.info "updating database record for user: #{user.id} and car: #{rec["car_id"]}"
            recomendation = UserCarRecomendation.where(user_id: user.id, car_id: rec["car_id"]).first_or_initialize
            recomendation.rank_score = rec["rank_score"]
            recomendation.save!
          end
        end
      rescue => e
        Rails.logger.error "Api error"
        p e.inspect
      end
    end
  end
end

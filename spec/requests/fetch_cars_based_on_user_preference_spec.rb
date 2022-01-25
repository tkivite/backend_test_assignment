require "rails_helper"

RSpec.describe "Car selection API", type: :request do
  before(:all) do
    @response = get "/usercarseleciton/#{@user.id}"
    res = JSON.parse response.body
    @data = res["data"]
  end

  describe "returns an array of records with correct data schema" do
    it "returns http-status 200" do
      p @response.headers["Current-Page"]
      expect(@response).to have_http_status(200)
    end
    it "returns array response" do
      expect(@data.kind_of?(Array)).to equal(true)
    end
    it "returns a single page" do
      expect(@data.size).to eql(ENV['DEFAULT_PAGE_SIZE'].to_i)
    end
    it "returns data elements with expected parameters" do
      expect(@data[0].keys).to match_array(["id", "brand", "price", "rank_score", "model", "label"])
    end
  end

  describe "returns well ordered records" do
    it "returns data with perfect matched records on top" do
      expect(@data[0]["label"]).to eql("perfect_match")
    end
  end
end

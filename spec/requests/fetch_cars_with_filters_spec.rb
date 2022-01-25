require "rails_helper"

RSpec.feature "Fetch cars with filters", :type => :feature do
  describe "with brand valid filter" do
    before do
      search_term = "Maxx"
      get "/usercarseleciton/1?page=1&query=#{search_term}"
    end
    it "returns only cars whose brands match the provided search query" do
      res = JSON.parse response.body
      data = res["data"]
      expect expect(data[0]["brand"]["name"].to_lower).includes(search_term.to_lower).to equal(true)
      expect expect(data[data.length - 1]["brand"]["name"].to_lower).includes(search_term.to_lower).to equal(true)
    end
  end
  describe "with brand invalid filter" do
    before do
      search_term = "Maxx"
      get "/usercarseleciton/1?page=1&query=#{search_term}"
    end
    it "returns an empty list" do
      res = JSON.parse response.body
      data = res["data"]
      expect expect(data.length).to equal(0)
    end
  end

  describe "with min price filter" do
    before do
      min_price = 36000
      get "/usercarseleciton/1?page=1&price_min=#{min_price}"
    end
    it "returns only cars whose price is higher than the provided price_min" do
      res = JSON.parse response.body
      data = res["data"]
      expect expect(data[0]["price"] >= min_price).to equal(true)
      expect expect(data[data.length - 1]["price"] >= min_price).to equal(true)
    end
  end
  describe "with max price filter" do
    before do
      max_price = 36000
      get "/usercarseleciton/1?page=1&query=vol&price_max=#{max_price}"
    end
    it "returns only cars whose price is less than the provided price_ax" do
      res = JSON.parse response.body
      data = res["data"]
      expect expect(data[0]["price"] <= min_price).to equal(true)
      expect expect(data[data.length - 1]["price"] <= min_price).to equal(true)
    end
  end
end

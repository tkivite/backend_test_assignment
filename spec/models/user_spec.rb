require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Associations' do
    it 'has_many user_car_recomendations' do
      association = described_class.reflect_on_association(:user_car_recomendations)
      expect(association.macro).to eq :has_many
    end
    it 'has_many user_preferred_brands' do
      association = described_class.reflect_on_association(:user_preferred_brands)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end
end
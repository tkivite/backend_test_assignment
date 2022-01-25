require 'rails_helper'

RSpec.describe Brand, type: :model do
  context 'Associations' do
    it 'has_many cars' do
      association = described_class.reflect_on_association(:cars)
      expect(association.macro).to eq :has_many
    end
  end
end
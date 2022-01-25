require 'rails_helper'

RSpec.describe Car, type: :model do
  context 'Associations' do
    it 'belongs_to brand' do
      association = described_class.reflect_on_association(:brand).macro
      expect(association).to eq :belongs_to
    end
  
  end
end

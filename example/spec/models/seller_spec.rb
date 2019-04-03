require 'rails_helper'

RSpec.describe Seller, type: :model do
  it 'FactoryBot create, build & build_stubbed lots of products and sellers' do
    100.times do
      FactoryBot.create(:product)
    end

    20.times do
      FactoryBot.build(:product, seller: FactoryBot.build(:seller))
    end

    10.times do
      FactoryBot.build_stubbed(:product)
    end
  end
end

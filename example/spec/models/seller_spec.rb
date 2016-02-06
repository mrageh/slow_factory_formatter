require 'rails_helper'

RSpec.describe Seller, type: :model do
  it 'FactoryGirl create, build & build_stubbed lots of products and sellers' do
    100.times do
      FactoryGirl.create(:product)
    end

    20.times do
      FactoryGirl.build(:product, seller: FactoryGirl.build(:seller))
    end

    10.times do
      FactoryGirl.build_stubbed(:product)
    end
  end
end

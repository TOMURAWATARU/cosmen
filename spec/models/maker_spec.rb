require 'rails_helper'

RSpec.describe Maker, type: :model do
  let!(:maker) { create(:maker) }

  it "有効な状態であること" do
    expect(maker).to be_valid
  end
end

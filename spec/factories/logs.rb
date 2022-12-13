FactoryBot.define do
  factory :log do
    content { "もう少し厚めに塗ってもOK" }
    association :cosme
  end
end

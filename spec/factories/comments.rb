FactoryBot.define do
  factory :comment do
    user_id { 1 }
    content { "厚く塗りすぎてしまったので、次からは薄めに塗る。" }
    association :cosme
  end
end

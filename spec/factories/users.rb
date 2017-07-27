FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
    sequence(:instagram_token) { |n| "token#{n.to_s * 10}" }
    sequence(:instagram_uid) { |n| "#{n.to_s * 5}" }
  end
end

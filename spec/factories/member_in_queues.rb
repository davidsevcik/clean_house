# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member_in_queue do
    member_id ""
    cleaning_queue_id ""
    position ""
  end
end

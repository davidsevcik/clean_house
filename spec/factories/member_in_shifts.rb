# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :member_in_shift do
    cleaning_queue_id 1
    member_id 1
  end
end

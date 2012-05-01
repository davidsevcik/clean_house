# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cleaning_queue do
    name "MyString"
    monday false
    tuesday false
    wednesday false
    thursday false
    friday false
    saturday false
    sunday false
  end
end

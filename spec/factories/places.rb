# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :place, :class => 'Places' do
    name "MyString"
    title "MyString"
  end
end

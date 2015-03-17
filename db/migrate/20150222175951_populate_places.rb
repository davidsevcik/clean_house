class PopulatePlaces < ActiveRecord::Migration
  def up
    Place.create!(name: 'brno', title: 'Brno')
    Place.create!(name: 'ostrava', title: 'Ostrava')
  end

  def down
  end
end

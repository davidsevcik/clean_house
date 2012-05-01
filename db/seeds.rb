# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


seeds_path = Rails.root.join('db', 'seeds')

File.open(seeds_path.join 'women.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "#{name.gsub(' ', '-')}@diamond.way", phone: '123456789', woman: true)
end

File.open(seeds_path.join 'men.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "#{name.gsub(' ', '-')}@diamond.way", phone: '123456789', woman: false)
end

File.open(seeds_path.join 'unactive.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "#{name.gsub(' ', '-')}@diamond.way", phone: '123456789', active: false)
end

File.open(seeds_path.join 'residents.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "#{name.gsub(' ', '-')}@diamond.way", phone: '123456789', resident: true)
end
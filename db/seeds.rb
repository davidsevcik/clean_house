# encoding: utf-8

seeds_path = Rails.root.join('db', 'seeds')

File.open(seeds_path.join 'women.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "david.sevcik@gmail.com", phone: '123456789', woman: true)
end

File.open(seeds_path.join 'men.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "david.sevcik@gmail.com", phone: '123456789', woman: false)
end

File.open(seeds_path.join 'unactive.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "david.sevcik@gmail.com", phone: '123456789', active: false)
end

File.open(seeds_path.join 'residents.txt').each_line do |line|
  name = line.strip()
  Member.create(name: name, email: "david.sevcik@gmail.com", phone: '123456789', resident: true)
end


workday_queue = CleaningQueue.create(name: "Úklid v pracovní den", system_name: 'workday')
weekend_queue = CleaningQueue.create(name: "Víkendový úklid", system_name: 'weekend')
residents_queue = CleaningQueue.create(name: "Služba rezidentů", system_name: 'residents')


regular_members = Member.regulars

regular_members.shuffle.each do |member|
  workday_queue.add_member member
end

regular_members.shuffle.each do |member|
  weekend_queue.add_member member
end

Member.residents.shuffle.each do |member|
  residents_queue.add_member member
end

start = Date.new(2012, 9)
(start..(start + 90)).each do |date|
  Shift.auto_plan(date)
end



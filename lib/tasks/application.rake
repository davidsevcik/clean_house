# encoding: utf-8

task :auto_plan, [:start_date, :end_date] => :environment do |t, args|
  if (args.start_date && args.end_date) || (ENV['start'] && ENV['end'])
    (Date.parse(ENV['start'] || args.start_date)..(Date.parse(ENV['end'] || args.end_date))).each do |date|
      Planner.auto_plan(date)
    end
  else
    date = Shift.order(:end_at).last.end_at + 1
    Planner.auto_plan(date)
  end
end

task :send_reminders, [:date] => :environment do |t, args|
  date = args[:date] ? Date.parse(args[:date]) : Date.today
  Reminder.send_for_date(date)
end


task :check => :environment do
  Member.regulars.map do |member|
    workday_num = Shift.where(name: 'workday').select {|shift| shift.member_ids.include?(member.id) }.size
    weekend_num = Shift.where(name: 'weekend').select {|shift| shift.member_ids.include?(member.id) }.size
    puts "#{workday_num}, #{weekend_num} - #{member.name}"
  end

end

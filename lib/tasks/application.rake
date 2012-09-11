# encoding: utf-8

task :auto_plan, [:start_date, :end_date] => :environment do |t, args|
  if (args.start_date && args.end_date) || (ENV['start'] && ENV['end'])
    (Date.parse(ENV['start'] || args.start_date)..(Date.parse(ENV['end'] || args.end_date))).each do |date|
      Shift.auto_plan(date)
    end
  else
    date = Shift.order(:end_at).last.end_at + 1
    Shift.auto_plan(date)
  end
end

task :send_reminders, [:date] => :environment do |t, args|

  body = "Ahoj,\n\n" +
    "%s - %s máš úklid v brněnském buddhistickém centru " +
    "v rámci skupinky: \n\n%s\n\n" +
    "Dlouhodobý rozpis úklidů najdeš na adrese http://clean-house.herokuapp.com\n\n" +
    "S přáním pěkného dne,\n" +
    "Tvůj připomínkový robot"

  ref_date = args[:date] ? Date.parse(args[:date]) : Date.today

  {(ref_date + 7) => 'za týden', (ref_date + 1) => 'zítra'}.each_pair do |date, label|
    shift = Shift.find_by_start_at(date)
    if shift
      emails = shift.members.map(&:email).reject(&:blank?)
      member_names = shift.members.map {|m| " - #{m.name} (#{m.email}, tel: #{m.phone})" }.join("\n")
      dates = shift.start_at == shift.end_at ? I18n.l(shift.start_at) : "od #{I18n.l(shift.start_at)} do #{I18n.l(shift.end_at)}"

      if Rails.env.production?
        unless emails.empty?
          Pony.mail(
            to: emails,
            bcc: 'david.sevcik@gmail.com',
            subject: "#{label.capitalize} máš úklid v centru",
            body: body % [label, dates, member_names]
          )
        end
      else
        puts body % [label, dates, member_names]
      end
    end
  end

end

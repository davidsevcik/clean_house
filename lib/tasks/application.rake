# encoding: utf-8

task :auto_plan => :environment do
  date = Shift.order(:start_at).last.start_at + 1
  Shift.auto_plan(date)
end

task :send_reminders => :environment do

  body = "Ahoj,\n\n" +
    "%s - %s máš úklid v brněnském buddhistickém centru " +
    "v rámci skupinky: %s.\n\n" +
    "S přáním pěkného dne,\n" +
    "Tvůj připomínkový robot"

  {(Date.today + 7) => 'za týden', (Date.today + 1) => 'zítra'}.each_pair do |date, label|
    shift = Shift.find_by_start_at(date)
    if shift
      emails = shift.members.map(&:email).reject(&:blank?)
      member_names = shift.members.map(&:name).join(', ')
      dates = shift.start_at == shift.end_at ? I18n.l(shift.start_at) : "od #{I18n.l(shift.start_at)} do #{I18n.l(shift.end_at)}"
      unless emails.empty?
        Pony.mail(
          to: emails,
          bcc: 'david.sevcik@gmail.com',
          subject: "#{label.capitalize} máš úklid v centru",
          body: body % [label, dates, member_names]
        )
      end
    end
  end

end

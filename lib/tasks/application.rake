# encoding: utf-8

task :auto_plan => :environment do
  date = Shift.order(:start_at).last.start_at + 1
  Shift.auto_plan(date)
end

task :send_reminders => :environment do
  #next week
  shift = Shift.find_by_start_at(Date.today + 7)
  if shift
    emails = shift.members.map(&:email).reject(&:blank?)
    names = shift.members.map(&:name).join(', ')
    unless emails.empty?
      Pony.mail(
        to: emails,
        subject: "Za týden máš úklid v centru",
        body: "Ahoj,\n\n" +
          "za týden - #{I18n.l shift.start_at} máš úklid v brněnském buddhistickém centru " +
          "v rámci skupinky: #{names}.\n\n" +
          "S přáním pěkného dne,\n" +
          "Tvůj připomínkový robot"
      )
    end
  end

  #tomorow
  shift = Shift.find_by_start_at(Date.today + 1)
  if shift
    emails = shift.members.map(&:email).reject(&:blank?)
    names = shift.members.map(&:name).join(', ')
    unless emails.empty?
      Pony.mail(
        to: emails,
        subject: "Zítra máš úklid v centru",
        body: "Ahoj,\n\n" +
          "zítra - #{I18n.l shift.start_at} máš úklid v brněnském buddhistickém centru " +
          "v rámci skupinky: #{names}.\n\n" +
          "S přáním pěkného dne,\n" +
          "Tvůj připomínkový robot"
      )
    end
  end
end

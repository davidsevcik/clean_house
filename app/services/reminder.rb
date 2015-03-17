class Reminder
  class << self
    def send_for_date(date = Date.today)
      body_template = "Ahoj,\n\n" +
        "%s - %s máš úklid v buddhistickém centru %s" +
        "%s\n\n" +
        "Dlouhodobý rozpis úklidů najdeš na adrese http://clean-house.herokuapp.com/calendar/%s\n\n" +
        "S přáním pěkného dne,\n" +
        "Tvůj připomínkový robot"

      {(date + 7) => 'za týden', (date + 1) => 'zítra'}.each_pair do |date, label|
        Shift.where(start_at: date).each do |shift|
          emails = shift.members.map(&:email).reject(&:blank?)
          if shift.members.size > 1
            member_names = "v rámci skupinky: \n\n" + (shift.members.map {|m| " - #{m.name} (#{m.email}, tel: #{m.phone})" }.join("\n"))
          else
            member_names = ''
          end
          dates = shift.start_at == shift.end_at ? I18n.l(shift.start_at) : "od #{I18n.l(shift.start_at)} do #{I18n.l(shift.end_at)}"
          body = body_template % [shift.place.title, label, dates, member_names, shift.place.name]

          send_email(adresses, label, body)
        end
      end
    end

    private

    def send_emails(adresses, time_exp, body)
      if Rails.env.production?
        unless emails.empty?
          Pony.mail(
            to: adresses,
            bcc: 'david.sevcik@gmail.com',
            subject: "#{time_exp.capitalize} máš úklid v centru",
            body: body
          )
        end
      else
        puts body
      end
    end
  end
end

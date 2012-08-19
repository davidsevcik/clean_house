Pony.options = {
  :from => 'no-reply@clean-house.herokuapp.com',
  :bcc => 'david.sevcik@gmail.com',
  :charset => 'utf-8',
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => ENV['SENDGRID_USERNAME'],
    :password => ENV['SENDGRID_PASSWORD'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

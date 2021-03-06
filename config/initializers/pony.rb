Pony.options = {
  :from => 'no-reply@clean-house.herokuapp.com',
  :charset => 'utf-8',
  :via => :smtp,
  :via_options => {
    :address => 'smtp.sendgrid.net',
    :port => '587',
    :domain => 'heroku.com',
    :user_name => 'apikey',
    :password => ENV['SENDGRID_API_KEY'],
    :authentication => :plain,
    :enable_starttls_auto => true
  }
}

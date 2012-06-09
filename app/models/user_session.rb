# encoding: utf-8

class UserSession
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :username, :password

  USERNAME = 'master'
  PASSWORD = 'cleaner'

  def persisted?
    false
  end

  validates_each :username, :password do |record, attr, value|
    case attr
      when 'username'
        record.errors.add(attr, 'neexistuje.') unless value == USERNAME
      when 'password'
        record.errors.add(attr, 'je chybné.') unless value == PASSWORD
    end
  end
end

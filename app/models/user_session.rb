# encoding: utf-8

class UserSession
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :username, :password

  USERNAME = 'master'
  PASSWORD = 'cleaner'

  def initialize(attributes={})
    attributes.each_pair do |key, value|
      send "#{key}=", value if respond_to? "#{key}="
    end
  end

  def persisted?
    false
  end

  def valid?
    if errors.empty?
      errors.add(:username, 'neexistuje.') unless username == USERNAME
      errors.add(:password, 'je chybné.') unless password == PASSWORD
    end
    errors.empty?
  end

  # validates_each :username, :password do |record, attr, value|
  #   case attr
  #     when 'username'
  #       record.errors.add(attr, 'neexistuje.') unless value == USERNAME
  #     when 'password'
  #       record.errors.add(attr, 'je chybné.') unless value == PASSWORD
  #   end
  # end
end

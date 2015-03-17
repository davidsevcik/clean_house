# encoding: utf-8
require 'digest/sha1'

class UserSession
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :username, :password, :place

  def initialize(attributes={})
    attributes.each_pair do |key, value|
      send "#{key}=", value if respond_to? "#{key}="
    end

    if password
      sha_password = Digest::SHA1.hexdigest(password)
      self.place = Place.where(login: username, password: sha_password).first
    end
  end

  def persisted?
    false
  end

  def valid?
    errors.add(:username, 'neexistuje nebo je chytné heslo.') unless self.place
    errors.empty?
  end
end

module CrudStar
  class User < ActiveRecord::Base
    attr_accessor :password
    
    validates_presence_of :username, :name
    
    # validates_uniqueness_of doesn't take into account a user may
    # be updating their own details
    validate :only_one_user_has_username
    def only_one_user_has_username
      records = CrudStar::User.where(:username => username).count
      failed = new_record? ? records > 0 : records > 1
      if failed
        errors.add(:username, "has already been taken")
      end
    end

    validates_presence_of :password, :on => :create
  
    def self.authenticate(login, pass)
      User.find_by_username_and_encrypted_password(login, User.md5(pass))
    end
  
    def self.md5(pass)
      Digest::MD5.hexdigest("--sadfsdfa-dsaf874--#{pass}")
    end
    
    def password=(value)
      self[:encrypted_password] = User.md5(value) unless value.blank?
      @password = value
    end
  end
end

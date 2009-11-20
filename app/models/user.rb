require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email,                                           :on => :create
  validates_presence_of     :password,                   :if => :password_required?,  :on => :create
  validates_presence_of     :password_confirmation,      :if => :password_required?,  :on => :create
  validates_length_of       :password, :within => 4..40, :if => :password_required?,  :on => :create
  validates_confirmation_of :password,                   :if => :password_required?,  :on => :create
  validates_length_of       :login,    :within => 3..40,                              :on => :create
  validates_length_of       :email,    :within => 3..100,                             :on => :create
  validates_uniqueness_of   :login, :email, :case_sensitive => false,                 :on => :create
  before_save :encrypt_password
  
  ###############
  #custom methods
  ###############
   has_one :profile, :dependent => :destroy
   
   attr_accessor :reg_key
   attr_accessible :profile, :reg_key
   
   validates_presence_of :reg_key
   validates_format_of :reg_key, :with => /^sfif is over 9000!$/
   
   after_create :create_new_profile
   
  #create user profile on creating a user
  def create_new_profile
    create_profile
  end
  
  #Virtual attribute for vidvatar's image url
  attr_accessor :vidvatar_img_url
  
  ################
  #default methods
  ################
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end
  
  #forces params[:id] to be the username
  def to_param
    login
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end
    
    
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :timeoutable, :timeout_in => 1.minutes

  after_update :send_password_change_email, if: :needs_password_change_email?

  ROLES = %i[admin user]

  def roles=(roles)
  	roles = [*roles].map { |r| r.to_sym }
  	self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.inject(0, :+)
  end

  def roles
  	ROLES.reject do |r|
  	  ((roles_mask.to_i || 0) & 2**ROLES.index(r)).zero?
	end
  end

  def has_role?(role)
  	roles.include?(role)
  end

  private
  def needs_password_change_email?
    encrypted_password_changed? && persisted?
  end
   
  def send_password_change_email
    UserMailer.password_changed(id).deliver
  end

end

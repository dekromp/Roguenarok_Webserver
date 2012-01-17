class User < ActiveRecord::Base
  has_many :roguenarok
  validates_format_of :email, :with => /\A([^@\s])+@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i  , :message => "address is not valid.\n", :allow_blank => true
end

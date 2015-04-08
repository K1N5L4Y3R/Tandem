class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_attached_file :avatar, styles: { thumb: "100x100#", medium: "400x400#" }
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/
end

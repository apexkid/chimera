class Profile < ActiveRecord::Base

  attr_accessible :occupation, :gender, :dob, :mobile, :name, 
  	:zip_code, :state, :country, :city
  belongs_to :user, :foreign_key => "user_id"

  VALID_GENDERS = ["Male", "Female"]
  START_YEAR = 1900
  VALID_DATES = DateTime.new(START_YEAR)..DateTime.now()


  validates(:mobile, :length => {:maximum => 12, :minimum => 10})
  validates(:user_id, :presence => true)
  validates_inclusion_of(:gender, :in => VALID_GENDERS, :presence => true, :message => "Must be male or female")
  #validates_inclusion_of(:dob, :in => VALID_DATES)
end

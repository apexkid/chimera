class Relationship < ActiveRecord::Base
  self.inheritance_column = nil
  attr_accessible :friend_id, :status, :type
  
  belongs_to :user
  belongs_to :friend, :class_name => "User", :foreign_key => "friend_id"
 
  validates_presence_of :user_id, :friend_id
end

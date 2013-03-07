class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  has_one :profile, :dependent => :destroy
  
  has_many :relationships, :foreign_key => :user_id, :dependent => :destroy
  has_many :reverse_relationships, :foreign_key => "friend_id", 
    :class_name => "Relationship", :dependent => :destroy
  
  has_many :direct_friends, :through => :relationships, 
    :conditions => "status = 'accepted'", :source => :friend
  has_many :reverse_friends, :through => :reverse_relationships,
    :conditions => "status = 'accepted'", :source => :user
  
  has_many :requested_friends, :through => :reverse_relationships,
    :source => :user, :conditions => "status = 'hold' AND type = 'friend'", :order => :created_at
  has_many :pending_friends, :through => :relationships, 
    :source => :friend, :conditions => "status = 'hold' AND type = 'friend'", :order => :created_at

  has_many :followers, :through => :reverse_relationships,
    :source => :user, :conditions => "type = 'subscribed'", :order => :created_at
  has_many :following, :through => :relationships,
    :source => :friend, :conditions => "type = 'subscribed'", :order => :created_at
  

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  def friends
    direct_friends | reverse_friends
  end

  #Checks
  def isfriends?(friend)
    @all_friends = self.friends
    @all_friends.include?(friend)
  end

  def ispendingfriends?(friend)
    self.pending_friends(true).include?(friend)
  end

  def isrequestedfriends?(friend)
    self.requested_friends(true).include?(friend)
  end

  def has_pending_friend_relation?(friend)
    ispendingfriends?(friend) || isrequestedfriends?(friend)
  end

  def isfollowing?(entity)
    self.following(true).include?(entity)
  end

  #Actions::
  def send_friend_request!(friend)
    if(!isfriends?(friend) && !self.has_pending_friend_relation?(friend))
      self.relationships.create(:friend_id => friend.id, :status => "hold", :type => "friend")
      friend.requested_friends(true)
    end
  end

  def accept_friend_request!(friend)
    if (isrequestedfriends?(friend))
      r = Relationship.find(:first, :conditions => ['user_id = ? AND friend_id = ? AND status = "hold"', friend.id, self.id ])
      r.status = "accepted"
      r.save
    end
  end

  def cancel_friend_request!(friend)
    if(ispendingfriends?(friend))
      relationships.find_by_friend_id(friend).destroy
      self.pending_friends(true)
    end
  end

  def reject_friend_request!(friend)
    if(self.isrequestedfriends?(friend))
      reverse_relationships.find_by_user_id(friend).destroy
      self.requested_friends(true)
    end
  end

  def unfriend!(friend)
    if(isfriends?(friend))
      #@rel = relationships.find_by_friend_id(friend)
      @rel = relationships.find(:first, :conditions => ["friend_id = ? AND type = 'friend'", friend.id])
      
      if !@rel.nil?
        #relationships.find_by_friend_id(friend).destroy 
        @rel.destroy
        #relationships.find(:first, :conditions => ["friend_id = ? AND type = 'friend'", friend.id]).destroy
      else
        #reverse_relationships.find_by_user_id(friend).destroy
        reverse_relationships.find(:first, :conditions => ["user_id = ? AND type = 'friend'", friend.id]).destroy
      end
      self.direct_friends(true)
      self.reverse_friends(true)
      friend.direct_friends(true)
      friend.reverse_friends(true)
    end
  end

  def follow!(entity)
    if(!isfollowing?(entity))
      self.relationships.create(:friend_id => entity.id, :status => "nil", :type => "subscribed")
      self.following(true)
    end
  end

  def unfollow!(entity)
    if(isfollowing?(entity))
      @rel = relationships.find(:first, :conditions => ["friend_id = ? AND type = 'subscribed'", entity.id])
      
      if !@rel.nil? 
        @rel.destroy
      else
        reverse_relationships.find(:first, :conditions => ["user_id = ? AND type = 'subscribed'", entity.id]).destroy
      end
      self.following(true)
    end
  end
end

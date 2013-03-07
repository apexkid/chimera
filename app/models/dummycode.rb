  # Function to find if a pair of friend exist
  def self.exists_friend?(user, friend)
  	!find(:all, :conditions => ['user_id = ? 
  		AND friend_id = ? AND type = ?', 
  		user.id, friend.id, "friend"]).nil?
  end

  # Record a pending friend request
  def self.request_friend(user, friend)
  	unless user == friend || Relationship.exists_friend?(user, friend)
  		transaction do
  			create(:user => user, :friend => friend, :status => "pending", :type ="friend")
   			create(:user => friend, :friend => user, :status => "requested", :type ="friend")
 		end
 	end
 end

 #Accept a friend request
 def self.accept_friend(user, friend)
 	transaction do
 		accepted_at = DateTime.now()
 		accept_one_side(user, friend, "friend", accepted_at)
 		accept_one_side(user, friend, "friend", accepted_at)
 	end
 end

 def self.breakup_friend(user, friend)
 	if exists_friend?(user, friend)
 		transaction do
 			destroy(find(:all, :conditions => ['user_id = ? 
  				AND friend_id = ? AND type = ?', 
  				user.id, friend.id, "friend"]))
 			destroy(find(:all, :conditions => ['user_id = ? 
  				AND friend_id = ? AND type = ?', 
  				friend.id, user.id, "friend"]))
 		end
 	end
 end

 private

 def accept_one_side(user, friend, type, accepted_at)
 	request = find(:all, :conditions => ['user_id = ? 
  		AND friend_id = ? AND type = ?', 
  		user.id, friend.id, type])
 	request.status = "accepted"
 	request.accepted_at = accepted_at
 	request.save!
 end
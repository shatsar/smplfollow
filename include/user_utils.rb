require 'rubygems'
require 'date'

def getFof(userId)
  user = Fof.find_by_user_id(userId)
  if(user == nil)
    user = Fof.create(:user_id => userId)
  end
  return user
end

def user_sucks(u)
  u.protected or u.profile_image_url.include? "images/default_profile_"
end

def previously_followed(userId) 
  return Unfollow.find_by_user_id(userId) != nil
end

def time_to_unfollow(userId)
  follow = Follow.find_by_user_id(userId)
  flag = true
  if(follow != nil)
    flag = (Date.today - follow.follow_date).to_i > 2
  end
  return flag
end
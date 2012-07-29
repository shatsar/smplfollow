def get_twitter_client
  Twitter.configure do |config|
    config.consumer_key = $consumerKey
    config.consumer_secret = $consumerSecret
    config.oauth_token = $accessToken
    config.oauth_token_secret = $accessTokenSecret
  end
  
  return Twitter::Client.new
end

def load_all &fun
  friend_list = []
  cursor = -1
  until cursor == 0
    result = fun[ cursor ]
    friend_list += result["ids"]
    cursor = result["next_cursor"]
  end
  return friend_list
end

def load_followers_third(client, target)
  beginning_time = Time.now
  cursor = -1
  counter = 2
  begin 
    result = client.follower_ids(target, :cursor => cursor)
    result.ids.each do |u| 
      fof = getFof(u)
      fof.third = true
      fof.save
    end
    cursor = result.next_cursor
    counter = counter - 1
  end while(cursor != 0 && counter > 0)
  end_time = Time.now
  return counter, (end_time - beginning_time)
end

def unfollow_unfollowers(client)
  currently_unfollowed = 0
  delta = Fof.find(:all, :conditions => ["friend = ? AND follower = ?", true, false])
  delta.each do |u|
    if time_to_unfollow u.user_id 
      begin
        client.friendship_destroy u.user_id 
        unfollow = Unfollow.create(:user_id => u.user_id, :unfollow_date => Date.today)
        currently_unfollowed = currently_unfollowed + 1
        if currently_unfollowed > $unfollow_limit then
          break
        end
      rescue => e
        $log.error e
      end
    end
  end   
  return currently_unfollowed
end


def follow_base(client, conditions)
  new_followed = 0
  delta = Fof.find(:all, :conditions => conditions)
  delta.each do |u|
    if (!previously_followed u.user_id)
        begin
          client.friendship_create u.user_id 
          follow = Follow.create(:user_id => u.user_id, :follow_date => Date.today)
          new_followed = new_followed + 1
        rescue => e
          $log.error e
        end
    end
  end
  return new_followed
end

def follow_followers_third(client)
  follow_base(client, ["friend = ? AND follower = ? AND third = ?", false, false, true])
end


def follow_followers(client)
  follow_base(client, ["friend = ? AND follower = ?", false, true])
end

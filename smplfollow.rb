require 'rubygems'
require 'date'
gem 'twitter', "=2.5.0"
require 'twitter'
require 'include/db.rb'
require 'include/db-utils.rb'
require 'include/user_utils.rb'
require 'include/twitter_utils.rb'
require 'include/config_utils.rb'
require 'parseconfig'
require 'optparse'

# Config
load_parameters(ARGV)
configfile = ParseConfig.new($configfile)
load_configuration(configfile)

client = get_twitter_client
connect $db_name 

Fof.delete_all

friend_list = load_all{ |c| client.friend_ids({:cursor => c}) }
load_in_db(friend_list, "friends"){ |fof| fof.friend = true }

follower_list = load_all{ |c| client.follower_ids({:cursor => c}) }
load_in_db(follower_list, "followers"){|fof| fof.follower = true }

if $unfollow then
  num = unfollow_unfollowers(client)
  puts "Unfollowed #{num} users"
end

if $follow then
  num = follow_followers(client)  
  puts "Followed #{num} followers"
end


if $follow_third then
  puts "Follow target: #{$follow_target}"
  load_followers_third(client, $follow_target)
  num = follow_followers_third client
  puts "Followed #{num} third party followers"
end

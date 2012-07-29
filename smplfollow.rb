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
require 'log4r'
require 'log4r/yamlconfigurator'

include Log4r

# Config
load_parameters(ARGV)
configfile = ParseConfig.new($configfile)
load_configuration(configfile)

init_logger

$log.debug "connecting to twitter"  
client = get_twitter_client

$log.debug "connecting to database"
connect $db_name 

$log.debug "clearing Fof table"
Fof.delete_all

$log.debug "loading friends"
friend_list = load_all{ |c| client.friend_ids({:cursor => c}) }
load_in_db(friend_list, "friends"){ |fof| fof.friend = true }

$log.debug "loading followers"
follower_list = load_all{ |c| client.follower_ids({:cursor => c}) }
load_in_db(follower_list, "followers"){|fof| fof.follower = true }

if $unfollow then
  num = unfollow_unfollowers(client)
  $log.info "Unfollowed #{num} users"
end

if $follow then
  num = follow_followers(client)  
  $log.info "Followed #{num} followers"
end


if $follow_third then
  $log.info "Follow target: #{$follow_target}"
  load_followers_third(client, $follow_target)
  num = follow_followers_third client
  $log.info "Followed #{num} third party followers"
end

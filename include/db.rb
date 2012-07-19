require 'active_record'

def connect(dbName)
  ActiveRecord::Base.establish_connection(
     :adapter => "sqlite3",
     :database  => dbName
  )
end


=begin
ActiveRecord::Schema.define do
	create_table :unfollows do |table|
		table.column :user_id, :int
		table.column :unfollow_date,:date
	end
	
	create_table :follows do |table|
		table.column :user_id, :int
		table.column :follow_date,:date
	end
	
	create_table :fofs do |table|
     table.column :user_id, :int
     table.column :friend,:boolean, :default => 0
     table.column :follower,:boolean, :default => 0
     table.column :third,:boolean, :default => 0
     table.column :protected,:boolean, :default => 0
	 end
	add_index(:fofs, :user_id, { :name => "fofs_users_id_index", :unique => true })
	add_index(:follows, :user_id, { :name => "follows_users_id_index", :unique => true })
	add_index(:unfollows, :user_id, { :name => "unfollows_users_id_index", :unique => true })
end
=end

class Unfollow < ActiveRecord::Base
end

class Follow < ActiveRecord::Base
end

class Fof <  ActiveRecord::Base
end

require 'faker'

namespace :db do
	desc "Fill database with sample data"
	task :populate => :environment do
		Rake::Task['db:reset'].invoke
		make_users
		make_profiles
		#make_relationships
	end

		
	def make_users
		admin = User.create!(:email => "example@test.com",
			:password => "foobar",
			:password_confirmation => "foobar")
		
		99.times do |n|
			email = "example-#{n+1}@test.com"
			password = "password"
			User.create!(:email => email,
			:password => password,
			:password_confirmation => password)
		end
	end

	def make_profiles
		User.all(:limit => 10).each do |user|
			@profile = user.build_profile(:name => Faker::Lorem.sentence(7), :city => Faker::Lorem.sentence(4),
			:mobile => "8090809022", :gender => "Male", :occupation => Faker::Lorem.sentence(7),
			:state => "Illinois", :country => "Japan", :zip_code => "11111001")
			@profile.save
		end
	end
end
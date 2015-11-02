require_relative '../../config/database'
# e.g., User.authenticate('
class User < ActiveRecord::Base

	# before_create

	validates :email, uniqueness: true, :format => { :with =>  /\w*[@]{1,}\w{1,}[.]\w{2,}/, :message => "@ required" } 
	# validates :username, uniqueness: true 

	has_many :products
	has_many :favourites
	has_many :categories

	def self.authenticate(email,password)
		# if email and password correspond to a valid user, return that user
		# otherwise, return nil	
		user_auth = User.find_by(email: email)
		if user_auth.password == password
			return user_auth
		else
			return nil		
		end
	end
end

require_relative '../../config/database'

class Category < ActiveRecord::Base

	belongs_to :user
	has_many :products
end
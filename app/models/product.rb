require_relative '../../config/database'

class Product < ActiveRecord::Base

	belongs_to :user
	belongs_to :category
	has_many :favourites
end
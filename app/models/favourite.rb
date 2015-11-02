require_relative '../../config/database'

class Favourite < ActiveRecord::Base

	belongs_to :user
	belongs_to :product
end
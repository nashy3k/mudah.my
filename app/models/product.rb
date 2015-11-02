require_relative '../../config/database'

# validates :title, presence: true
# validates :price, presence: true

class Product < ActiveRecord::Base

	belongs_to :user
	belongs_to :category
	has_many :favourites
end
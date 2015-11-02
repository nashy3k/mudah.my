require_relative '../../config/database'

validates :title, presence: true

class Category < ActiveRecord::Base

	belongs_to :user
	has_many :products
end
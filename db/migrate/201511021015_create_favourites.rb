class CreateFavourites < ActiveRecord::Migration
	def change
		create_table :favourites do |t|
			t.belongs_to :user, index: true 
			t.belongs_to :product, index: true 
			t.boolean :status
			t.string :title
			t.string :description
			t.timestamps null: false
		end
	end
end
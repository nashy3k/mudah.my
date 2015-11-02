class CreateProducts < ActiveRecord::Migration
	def change
		create_table :products do |t|
			t.belongs_to :user, index: true
			t.belongs_to :category, index: true			 
			t.string :title
			t.string :description
			t.string :price
			t.timestamps null: false
		end
	end
end
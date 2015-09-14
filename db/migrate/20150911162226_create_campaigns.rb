class CreateCampaigns < ActiveRecord::Migration
  def change
		create_table :campaigns do |t|
			t.string :title
			t.text :description
			t.string :rurl
			t.integer :clicks
			t.boolean :active

			t.timestamps null: false
		end
  end
end

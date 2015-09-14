class Campaign < ActiveRecord::Base
	validates :title, presence: true
end

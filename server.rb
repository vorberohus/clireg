require 'rubygems'
require 'sinatra/base'
require 'sinatra/activerecord'
require 'sanitize'
require 'json'

class Clireg < Sinatra::Base
	register Sinatra::ActiveRecordExtension

	configure do
		set :environment, :development
		set :rescue_clicks_path, 'accident/rescue_clicks.json' 
	end

	settings.database.connection

	Dir[File.dirname(__FILE__) + "/models/**", File.dirname(__FILE__) + "/routes/**"].each do |route|
			require route
	end
end




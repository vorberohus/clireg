class Clireg 
  #filters
	before do
		if params[:campaign] then
			params[:campaign].each do |key, param|
				params[:campaign][key] = Sanitize.clean param if param.is_a? String
			end
		end
	end
	#dashboard
	get '/' do
		haml :index
	end
	#campaigns/index
	get '/campaigns' do
		@campaigns = Campaign.all

		fp = settings.rescue_clicks_path
		if File::exist? fp then 
			clicks = JSON.parse File.read fp 
			ids = clicks.keys.map(){|sid| sid.delete 's'}
			Campaign.find(ids).each do |campaign|
				sid = 's'+campaign.id.to_s 
				if clicks[sid] then
					campaign.clicks += clicks[sid]
					campaign.save
				end
			end
			File.delete fp
		end
		
		if @campaigns.size > 0 then
			haml :'campaigns/index'
		else
			haml :'campaigns/index_empty'
		end
	end
	#campaigns/new
	get '/campaigns/new' do
		@campaign = Campaign.new
		haml :'campaigns/new'
	end
	#campaigns/create
	post '/campaigns/new' do
		@campaign = Campaign.new params[:campaign]
		@campaign.clicks = 0
		if @campaign.save then
			redirect to 'campaigns'
		else
			haml :'campaigns/new'
		end
	end
	#campaigns/edit
	get '/campaigns/:id/edit' do
		@campaign = Campaign.find params[:id]
		haml :'campaigns/edit'
	end
	#campaigns/update
	post '/campaigns/:id' do
		campaign = Campaign.find params[:id]
		campaign.update_attributes params[:campaign]
		redirect to 'campaigns'
	end
	#campaigns/delete
	post '/campaigns/:id/delete' do
		campaign = Campaign.find params[:id]
		campaign.delete
		redirect to 'campaigns'
	end
	#campaigns/visit
	get '/campaigns/:id/visit' do
		begin
			@campaign = Campaign.find params[:id]
			if @campaign.active then
				@campaign.clicks += 1
				@campaign.save
				if @campaign.rurl != '' then
					haml :'campaigns/visit', layout: :external_layout
				else
					redirect to 'campaigns'
				end
			else
				haml :'campaigns/inactive', layout: :external_layout
			end
		rescue Mysql2::Error
			sid = 's'+params[:id]
			fp = settings.rescue_clicks_path
			clicks = if File::exist? fp then JSON.parse File.read fp else {} end
			if clicks[sid] then
				clicks[sid]	+= 1
			else
				clicks[sid] = 1
			end

			File.open(fp, 'w') do |file|
				file.write clicks.to_json
			end

			haml :'errors/lost_db_connection', layout: :external_layout
		end
	end
end

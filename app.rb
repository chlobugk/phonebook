require 'sinatra'
require 'pg'
load './local_env.rb' if File.exists?('./local_env.rb')
db_params = {
    host: ENV['host'],
    port: ENV['port'],
    dbname: ENV['db_name'],
    user: ENV['user'],
    password: ENV['password']
}

db = PG::Connection.new(db_params)

get '/' do
	phonebook=db.exec("SELECT first_name, last_name, street_address, city, state, zip, cell_phone FROM phonebook");
	erb :index, locals: {phonebook: phonebook}
end

post '/phonebook' do 
	first_name = params[:first_name]
	last_name = params[:last_name]
	street_address = params[:street_address]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]
	cell_phone = params[:cell_phone]
	db.exec("INSERT INTO phonebook(first_name, last_name, street_address, city, state, zip, cell_phone) VALUES('#{first_name}', '#{last_name}', '#{street_address}', '#{city}', '#{state}', '#{zip}', '#{cell_phone}')"); 
	redirect '/'
end
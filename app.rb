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
	phonebook=db.exec("SELECT first_name, last_name, street_address, city, state, zip, mobile_number FROM phonebook");
	erb :index, locals: {phonebook: phonebook}
end

post '/phonebook' do 
	first_name = params[:first_name]
	last_name = params[:last_name]
	street_address = params[:street_address]
	city = params[:city]
	state = params[:state]
	zip = params[:zip]
	mobile_number = params[:mobile_number]
	db.exec("INSERT INTO phonebook(first_name, last_name, street_address, city, state, zip, mobile_number) VALUES('#{first_name}', '#{last_name}', '#{street_address}', '#{city}', '#{state}', '#{zip}', '#{mobile_number}')"); 
	redirect '/'
end

post '/update' do
   first_name_update = params[:first_name_update]
   fname = params[:fname]
   db.exec("UPDATE phonebook SET first_name = '#{first_name_update}' WHERE first_name = '#{fname}' ");
   redirect '/'
end

post '/delete' do
	trash_name = params[:trash_name]
db.exec("DELETE FROM phonebook WHERE first_name = '#{trash_name}' ");
redirect '/'
end

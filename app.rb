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
 	new_data = params[:new_data]
 	old_data = params[:old_data]
 	column = params[:contact]

 	case column
 	when 'col_first_name'
	    db.exec("UPDATE phonebook SET first_name = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_last_name'
	  	db.exec("UPDATE phonebook SET last_name = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_address'   	
	   	db.exec("UPDATE phonebook SET street_address = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_city'   	
	   	db.exec("UPDATE phonebook SET city = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_state'   	
	   	db.exec("UPDATE phonebook SET state = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_zip'   	
	   	db.exec("UPDATE phonebook SET zip = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	when 'col_cell'   	
	   	db.exec("UPDATE phonebook SET mobile_number = '#{new_data}' WHERE mobile_number = '#{old_data}' ");
	end
	redirect '/'
end

post '/delete' do
	trash = params[:trash]
db.exec("DELETE FROM phonebook WHERE mobile_number = '#{trash}' ");
redirect '/'
end

#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def init_db
	@db = SQLite3::Database.new 'leprosorium.db'
	@db.results_as_hash = true
end

before do
	init_db
end

configure do
	init_db
	@db.execute 'CREATE TABLE IF NOT EXISTS "Posts" (
		"id"	INTEGER NOT NULL,
		"created_date"	REAL,
		"content"	TEXT,
		PRIMARY KEY("id" AUTOINCREMENT)
	)'	
end

get '/' do
	erb :index
end

get '/new' do
	erb :new
end

post '/new' do
	init_db
	content = params[:content]

	if content.to_s.length <= 0
		@error = 'Type post text'
		return erb :new
	end

	@db.execute 'insert into Posts (content, created_date) values (?, datetime())' [content]
	erb "You typed: #{content}"
end
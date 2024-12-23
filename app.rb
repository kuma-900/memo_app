# frozen_string_literal: true

require 'sinatra'
require 'pg'

configure do
  set :db_connection, PG.connect(
    host: 'os3-387-26606.vs.sakura.ne.jp',
    dbname: 'memo_app',
    user: 'memo_user',
    password: ENV['DB_PASSWORD']
  )
  settings.db_connection.set_client_encoding('UTF8')
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def find_memo
  result = @db.exec_params(
    'SELECT * FROM memos WHERE id = $1',
    [params[:memo_id]]
  )
  result.first
end

before do
  @db = settings.db_connection
end

get '/memos' do
  @memos = @db.exec(
    'SELECT * FROM memos ORDER BY id ASC'
  )
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  @db.exec_params(
    'INSERT INTO memos
    (title, content) VALUES ($1, $2)',
    [params[:title], params[:content]]
  )
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = find_memo
  halt 404, 'メモが見つかりません' unless @memo
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo = find_memo
  halt 404, 'メモが見つかりません' unless @memo
  erb :edit
end

patch '/memos/:memo_id' do
  @db.exec_params(
    'UPDATE memos
    SET title = $1, content = $2
    WHERE id = $3',
    [params[:title], params[:content], params[:memo_id]]
  )
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  @db.exec_params(
    'DELETE FROM memos
    WHERE id = $1',
    [params[:memo_id]]
  )
  redirect '/memos'
end

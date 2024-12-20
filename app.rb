# frozen_string_literal: true

require 'sinatra'
require 'pg'

def db_connection
  conn = PG.connect(
    host: 'os3-387-26606.vs.sakura.ne.jp',
    dbname: 'memo_app',
    user: 'memo_user',
    password: ENV['DB_PASSWORD']
  )
  conn.set_client_encoding('UTF8')
  conn
end

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

get '/memos' do
  @memos = db_connection.exec(
    'SELECT * FROM memos'
  )
  db_connection.close
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  db_connection.exec_params(
    'INSERT INTO memos
    (title, content) VALUES ($1, $2)',
    [params[:title], params[:content]]
  )
  db_connection.close
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = db_connection.exec_params(
    'SELECT * FROM memos
    WHERE id = $1',
    [params[:memo_id]]
  ).first
  db_connection.close
  halt 404, 'メモが見つかりません' unless @memo
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo = db_connection.exec_params(
    'SELECT * FROM memos
    WHERE id = $1',
    [params[:memo_id]]
  ).first
  db_connection.close
  halt 404, 'メモが見つかりません' unless @memo
  erb :edit
end

patch '/memos/:memo_id' do
  db_connection.exec_params(
    'UPDATE memos
    SET title = $1, content = $2
    WHERE id = $3',
    [params[:title], params[:content], params[:memo_id]]
  )
  db_connection.close
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  db_connection.exec_params(
    'DELETE FROM memos
    WHERE id = $1',
    [params[:memo_id]]
  )
  db_connection.close
  redirect '/memos'
end

# frozen_string_literal: true

require 'sinatra'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def read_memos
  JSON.parse(File.read('data/memos.json'))
end

def find_memo(memo_id)
  read_memos.find { |memo| memo['id'] == memo_id.to_i}
end

def save_memos(memos)
  File.write('data/memos.json', JSON.pretty_generate(memos))
end

get '/memos' do
  @memos = read_memos
  erb :index
end

get '/memos/new' do
  erb :new
end

post '/memos' do
  memos = read_memos
  new_memo = {
    'id' => memos.empty? ? 1 : memos.last['id'] + 1,
    'title' => params[:title],
    'content' => params[:content]
  }
  memos << new_memo
  save_memos(memos)
  redirect '/memos'
end

get '/memos/:memo_id' do
  @memo = find_memo(params[:memo_id])
  halt 404, 'メモが見つかりません' unless @memo
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo = find_memo(params[:memo_id])
  halt 404, 'メモが見つかりません' unless @memo
  erb :edit
end

patch '/memos/:memo_id' do
  memos = read_memos
  memo = find_memo(params[:memo_id])
  halt 404, 'メモが見つかりません' unless memo
  memo['title'] = params[:title]
  memo['content'] = params[:content]
  save_memos(memos)
  redirect "/memos/#{params[:memo_id]}"
end

delete '/memos/:memo_id' do
  memos = read_memos
  memos.reject! { |memo| memo['id'] == params[:memo_id].to_i }
  save_memos(memos)
  redirect '/memos'
end

require 'byebug'

set :protection, except: :session_hijacking

get '/lobby' do
  if Game.all.count != 0
    @hostgames = Game.where('player1_id = ? or player2_id = ?', session[:user_id], session[:user_id])

    @challengergames = Game.where('player1_id != ?', "#{session[:user_id]}")
  else
    @nogames = "No games yet."
  end
  erb :'games/lobby'
end

get '/game/play/:game_id' do
  unless params[:observer] == "true"
    @game = Game.find(params[:game_id])
    unless (session[:user_id].to_i == @game.player1.id)
      @game.update(player2_id: session[:user_id], status: 1, turn: 1)
    end
  end
  erb :'games/game'
end

get '/game/create' do
  game = Game.create(player1_id: session[:user_id])
  redirect "/game/play/#{game.id}"
end

get '/game/play/:game_id/move' do
  @game = Game.find(params[:game_id])
  @moves = Move.where(game_id: @game.id)
  erb :'games/board', layout: false
end

post '/game/play/:game_id/play' do
  Move.create(user_id: session[:user_id], game_id: params[:game_id], x: params[:X], y: params[:Y])
  game = Game.find(params[:game_id])
  if game.turn == 1
    game.turn = 2
  else
    game.turn = 1
  end
  game.save
  redirect "/game/play/#{params[:game_id]}/move"
end
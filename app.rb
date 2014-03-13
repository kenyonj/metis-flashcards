require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'flashcards'
})

class Deck < ActiveRecord::Base
  has_many :cards
end

class Card < ActiveRecord::Base
  belongs_to :decks
end

get '/' do
  decks_unsorted = Deck.all
  @decks = decks_unsorted.sort_by { |key| key[:name] }
  erb :index
end

["/decks", "/decks/"].each do |path|
  get path do
    redirect "/"
  end
end

get '/decks/new' do
  erb :new_deck
end

get '/decks/:id/cards/new' do
  @deck = Deck.find(params[:id])
  erb :new_card
end

get '/decks/:deck_id/cards/:id' do
  @deck = Deck.find(params[:deck_id])
  @card = Card.find(params[:id])
  erb :card
end

get '/decks/:deck_id/cards/:id/edit' do
  @deck = Deck.find(params[:deck_id])
  @card = Card.find(params[:id])
  erb :edit_card
end

get '/decks/:id/edit' do
  @deck = Deck.find(params[:id])
  erb :edit_deck
end

get '/decks/:id' do
  @deck = Deck.find(params[:id])
  erb :deck
end

post '/decks/new' do
  deck = Deck.create(params[:deck])
  redirect "/decks/#{deck.id}"
end

post '/decks/:deck_id/cards/new' do
  deck = Deck.find(params[:deck_id])
  card = Card.new(params[:card])
  deck.cards << card
  redirect "/decks/#{deck.id}"
end

post '/decks/:deck_id/cards/:id/guess' do
  deck = Deck.find(params[:deck_id])
  card = Card.find(params[:id])
  card_guess = Card.new(params[:card])

  if card.back.strip.downcase == card_guess.back.strip.downcase
    "You are correct! <a href=\"/decks/#{deck.id}\">Click here to return to the #{deck.name.capitalize} deck.</a>"
  else
    "You are incorrect. The back of the #{card.front} card was #{card.back}. <a href=\"/decks/#{deck.id}\">Click here to return to the #{deck.name.capitalize} deck.</a>"
  end

end

patch '/decks/:deck_id/cards/:id' do
  card = Card.find(params[:deck_id])
  card.update(params[:card])
  redirect "/decks/#{card.deck_id}"
end

patch '/decks/:id' do
  deck = Deck.find(params[:id])
  deck.update(params[:deck])
  redirect "/decks/#{deck.id}"
end

delete '/decks/:id' do
  deck = Deck.find(params[:id])
  deck.destroy
  redirect "/"
end

delete '/decks/:deck_id/cards/:id' do
  card = Card.find(params[:id])
  card.destroy
  redirect "/decks/#{card.deck_id}"
end

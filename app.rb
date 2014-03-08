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

get '/decks/new' do
  erb :new_deck
end

get '/decks/:deck_id/cards/:id' do
  @deck = Deck.find(params[:deck_id])
  @card = Card.find(params[:id])
  erb :card
end

get '/decks/new' do
  erb :new_deck
end

get '/decks/:id' do
  @deck = Deck.find(params[:id])
  erb :deck
end

post '/decks/new' do
  deck = Deck.create(params[:deck])
  redirect "/decks/#{deck.id}"
end

delete '/decks/:id' do
  deck = Deck.find(params[:id])
  deck.destroy
  redirect "/"
end

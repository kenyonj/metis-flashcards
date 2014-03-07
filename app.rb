require 'sinatra'
require 'active_record'

ActiveRecord::Base.establish_connection({
  adapter: 'postgresql',
  database: 'flashcards'
})

class Gallery < ActiveRecord::Base
  has_many :images
end

class Image < ActiveRecord::Base
  belongs_to :gallery
end

get '/' do
  @galleries = Gallery.all
  erb :index
end

post '/galleries' do
  gallery = Gallery.create(params[:gallery])
  redirect "/galleries/#{gallery.id}"
end

post '/galleries/:id/images' do
  gallery = Gallery.find(params[:id])
  image = Image.new(params[:image])
  gallery.images << image
  redirect "/galleries/#{gallery.id}"
end

get '/galleries/:id/images/new' do
  @gallery = Gallery.find(params[:id])
  erb :new_image
end

get '/galleries/new' do
  erb :new_gallery
end

get '/galleries/:id' do
  id = params[:id]
  @gallery = Gallery.find(id)
  @images = @gallery.images
  erb :gallery
end

get '/galleries/:gallery_id/images/:id/edit' do
  @image = Image.find(params[:id])
  erb :edit_image
end

get '/galleries/:id/edit' do
  @gallery = Gallery.find(params[:id])
  erb :edit_gallery
end

patch '/galleries/:gallery_id/images/:id' do
  image = Image.find(params[:id])
  image.update(params[:image])
  redirect "/galleries/#{image.gallery_id}"
end

patch '/galleries/:id' do
  gallery = Gallery.find(params[:id])
  gallery.update(params[:gallery])
  redirect "/galleries/#{gallery.id}"
end

delete '/galleries/:gallery_id/images/:id' do
  image = Image.find(params[:id])
  image.destroy
  redirect "/galleries/#{image.gallery_id}"
end

delete '/galleries/:id' do
  gallery = Gallery.find(params[:id])
  gallery.destroy
  redirect "/"
end

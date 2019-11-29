Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :book, only: [:index, :show, :create, :update, :destroy], :path => 'books', :as => 'books'
  scope '/book', :controller => 'book' do
  	get '/genres', :action => 'index_genre'
  	post '/genres', :action => 'create_genre'
  	get '/genres/:id', :action => 'show_genre'
  	put '/genres/:id', :action => 'update_genre'
  	patch '/genres/:id', :action => 'update_genre'
  	delete '/genres/:id', :action => 'destroy_genre'
  end
end

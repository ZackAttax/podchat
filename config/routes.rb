Rails.application.routes.draw do
  root 'application#index'

  # get '/spotify_auth', to: 'application#spotify_auth'

  get 'comments/index'
  post 'comments/create'

  get 'episodes/show/:id', to: 'episodes#show'
  get 'episodes/index'
  get 'episodes/search'

  get 'podcasts/index'
  get 'podcasts/show/:id', to: 'podcasts#show'
  get 'podcasts/search'

  # get '/users/spotify/omniauth_authorize', to: 'users/omniauth_callbacks#spotify', as: :user_spotify_omniauth_authorize
  # devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions',
  # registrations: 'users/registrations'}
  # config/routes.rb
devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

# Custom route for Spotify OmniAuth authorization
# get '/users/spotify/omniauth_authorize', to: 'users/omniauth_callbacks#spotify', as: :user_spotify_omniauth_authorize


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end

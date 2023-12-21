Rails.application.routes.draw do
  root 'application#index'

  # get '/spotify_auth', to: 'application#spotify_auth'

  get 'comments/index'
  post 'comments/create'
  get 'comments/:comment_id/replies', to: 'replies#index', as: :comments_replies_index
  get 'comments/:comment_id/replies/hide', to: 'replies#hide', as: :comments_replies_hide
  post 'comments/:comment_id/replies', to: 'replies#create', as: :comments_replies_create

  get 'episodes/show/:id', to: 'episodes#show', as: :episodes_show
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

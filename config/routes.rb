Rails.application.routes.draw do
  root "application#index"

  get 'comments/index'
  post 'comments/create'

  get 'episodes/show/:id', to: 'episodes#show'
  get 'episodes/index'
  get 'episodes/search'

  get 'podcasts/index'
  get 'podcasts/show/:id', to: 'podcasts#show'
  get 'podcasts/search'


  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
end

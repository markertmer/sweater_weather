Rails.application.routes.draw do

  # namespace :api do
  #   namespace :v1 do
  #     # resources :backgrounds, only: :show
  #     get 'backgrounds', to: 'backgrounds#show'
  #   end
  # end

  get 'api/v1/backgrounds', to: 'backgrounds#show'
  get 'api/v1/forecast', to: 'forecast#show'
  get 'api/v1/munchies', to: 'munchies#show'

  post 'api/v1/users', to: 'users#create'
end

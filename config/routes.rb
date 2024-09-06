Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#index'
  get 'users/:email/download_orders', to: 'users#download_orders', as: 'download_orders', constraints: { email: /.*/ }
  get 'download_path', to: 'users#csv'

  # mount ActionCable.server => '/cable'
end

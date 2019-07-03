Rails.application.routes.draw do
  devise_for :users
  root to: 'timesheets#index'
  resources :timesheets, only: [:new, :create]
end

Rails.application.routes.draw do
  devise_for :users
  get 'timesheets/index'
  get 'timesheets/new'
  root to: 'timesheets#index'
  resources :timesheets, only: [:new, :create]
end

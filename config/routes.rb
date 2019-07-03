Rails.application.routes.draw do
  get 'timesheets/index'
  get 'timesheets/new'
  root to: 'timesheets#index'
  resources :timesheets, only: [:new, :create]
end

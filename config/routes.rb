Rails.application.routes.draw do
  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'timesheets#index'

      resources :timesheets, only: [:new, :create]

      resources :weekly_timesheets, only: [:index]
    end
  end

  unauthenticated :user do
    root 'devise/sessions#new'
  end
end

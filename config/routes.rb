Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root 'events#index'

  resources :events do
    member do
      get :delete
    end
  end
  
  resources :participations

  get 'events/delete'
  get 'events/edit'
  get 'events/index'
  get 'events/new'
  get 'events/show'
  get 'events/homepage'

  namespace :api, path: '/api' do
    get 'v1/events'
    get 'v1/event'
  end

  # method 'participations/new/:id', to: 'participations#action'
  # get 'participations/new/:id'
  # get 'events/:id/submit', action: :submit, controller: 'participation'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

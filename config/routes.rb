Rails.application.routes.draw do
  get 'bases/new'

  root 'static_pages#top'
  get '/signup', to: 'users#new'

  # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
      get 'attendances/edit_one_month'
      patch 'attendances/update_one_month'
    end
    resources :attendances, only: :update
  end

  get '/user/attendance_index', to: 'users#attendance_index'
  get 'modifying_basic_info', to: 'users#modifying_basic_info'
  resources :bases
end
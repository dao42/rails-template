require 'sidekiq/web'

class AdminConstraint
  def matches?(request)
    return false unless request.session[:current_admin_id].present?

    admin = Administrator.find_by(id: request.session[:current_admin_id])
    admin.present?
  end
end

Rails.application.routes.draw do
  namespace :admin do
    get 'login', to: 'sessions#new', as: :login
    post 'login', to: 'sessions#create'
    delete 'logout', to: 'sessions#destroy', as: :logout
    resource :account, only: [:edit, :update]

    root to: 'dashboard#index'
  end

  # write your routes here

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
  mount ActionCable.server => '/cable'
  root to: 'home#index'
end

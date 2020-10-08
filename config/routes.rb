Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  devise_scope :user do
    get 'users/employee_uniquness', to: 'users/registrations#employee_uniquness'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'notes#index'
  resources :care_receivers, only: %i[new create show]
  resources :medicines, only: %i[index create]
end

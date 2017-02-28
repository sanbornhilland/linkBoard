Rails.application.routes.draw do

  resources :boards, only: [:show] do
  	resources :links, only: [:create, :index]
  end
end

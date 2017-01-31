Rails.application.routes.draw do

  resources :boards, only: [:show] do
  	resources :links, only: [:create]
  end

end

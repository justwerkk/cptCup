CptCup::Application.routes.draw do
  resources :games

  get "home/index"

  root :to => "home#index"
end

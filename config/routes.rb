CptCup::Application.routes.draw do
  resources :players
  resources :games

  get "home/index"

  root :to => "home#index"
end

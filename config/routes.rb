CptCup::Application.routes.draw do
  resources :players
  resources :games do
    get :odds, :on => :collection
  end

  get "home/index"

  root :to => "home#index"
end

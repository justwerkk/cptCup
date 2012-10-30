CptCup::Application.routes.draw do
  resources :players
  resources :games do
    get :odds, :on => :collection
  end

  root :to => "home#index"
end

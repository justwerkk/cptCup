CptCup::Application.routes.draw do
  resources :players
  resources :games do
    get :odds, :on => :collection
  end

  match 'comparisons' => 'home#comparisons', :as => :comparisons

  root :to => "home#index"
end

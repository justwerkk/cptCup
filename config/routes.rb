CptCup::Application.routes.draw do
  resources :players

  resources :leagues do
    resources :games do
      get :odds, :on => :collection
    end
  end

  match 'comparisons' => 'home#comparisons', :as => :comparisons1
  match 'comparisons2' => 'home#comparisons2', :as => :comparisons2
  match 'comparisons3' => 'home#comparisons3', :as => :comparisons3

  root :to => "home#index"
end

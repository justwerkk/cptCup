CptCup::Application.routes.draw do
  resources :players
  resources :games do
    get :odds, :on => :collection
  end

  get "sandbox" => "sandbox#index"
  get "sandbox/child" => "sandbox#child", as: :child_popup
  get "sandbox/other_page" => "sandbox#other_page", as: :other_page

  root :to => "home#index"
end

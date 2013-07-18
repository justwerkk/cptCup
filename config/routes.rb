CptCup::Application.routes.draw do
  resources :players

  resources :leagues do
    resources :games do
      get :odds, :on => :collection
    end
  end

  namespace :admin do
    resources :leagues, except: :show
  end

 root :to => "leagues#index"
end

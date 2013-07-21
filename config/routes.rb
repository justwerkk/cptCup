CptCup::Application.routes.draw do
  resources :players

  resources :leagues do
    resources :games do
      get :odds, :on => :collection
      get :shot_tracker, :on => :member
      post :create_shot, :on => :member
    end
  end

  namespace :admin do
    resources :leagues, except: :show
    resources :games, except: :show
  end

  get '/admin' => "admin/leagues#index"
  root :to => "leagues#index"
end

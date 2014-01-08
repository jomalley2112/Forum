Forum::Application.routes.draw do
  
  get "comments/new"
  get "comments/edit"
  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"
  get 'update_user_email' => 'users#update_user_email', :as => 'update_user_email'
  get "user_posts" => 'posts#user_posts', :as => 'user_posts'
  get "destroy_post" => 'posts#destroy', :as => "destroy_post"
  
  #Not sure why these all need to be spelled out when I have the posts resource below
  get "posts/index"
  get "posts/show"
  get "posts/edit"
  get "posts/new"
  get "posts/destroy"
  

  resources :users
  resources :sessions
  resources :posts do
    resources :comments
  end
  root :to => 'posts#index'
end

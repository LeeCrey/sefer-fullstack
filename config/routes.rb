# frozen_string_literal: true

Rails.application.routes.draw do
  root "posts#index"

  resources :notifications
  resources :chats, shallow: true do
    resources :messages, only: %i[index create update destroy] do
      # collection do
      #   post :index
      # end
    end
  end
  resources :users, only: %i[index show], shallow: true do
    member do
      post "follow" => "follow#follow"
      # delete "unfollow" => "users#unfollow"
      get "followers" => "follow#followers"
      get "followings" => "follow#followings"
      delete "unblock" => "blocked_user#destroy"
      post "block" => "blocked_user#create"
      post "hide" => "users#hide"
    end
  end
  get "online" => "users#online", as: :online_friends
  get "search" => "users#search"
  get "blocked_users" => "blocked_users#index"
  resources :posts, except: %i[index], shallow: true do
    member do
      post "vote" => "posts#vote"
    end
  end

  get "terms" => "helpers#terms", as: :terms_of_use
  get "privacy-policy" => "helper#privacy", as: :privacy_policy

  devise_for :users,
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
             },
             controllers: {
               sessions: "user/sessions",
               registrations: "user/registrations",
               passwords: "user/passwords",
               unlocks: "user/unlocks"
             }

  # match "*unmatched", to: "application#not_found", via: :all
end

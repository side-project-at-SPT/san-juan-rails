Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      match "walking-skeleton", to: "walking_skeleton#show", via: :all

      resources :game, only: [ :create ] do
        member do
          put "players", to: "game#join_game"
          put "ready", to: "game#set_player_ready"
          post "select-role-card", to: "game#select_role_card"
        end
      end
    end
  end

  if Rails.env.development?
    mount Rswag::Ui::Engine => "/api-docs"
    mount Rswag::Api::Engine => "/api-docs"
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root to: "api/v1/walking_skeleton#show"
end

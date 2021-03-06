Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "users/registrations"}
  scope "/profile" do
    get "/", to: "static#profile"
    post "/confirm/:id", to: "matches#confirm"
    resources :user_languages, path: "languages"
    resources :language_interests, path: "interests"
    resources :matches
  end
  root 'static#index'
end

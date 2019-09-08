Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth'
      get 'health', to: 'health#health'
      get 'currentUser', to: 'health#user'
      resources :forms
      resources :galaxies
      resources :planets
    end
  end
end

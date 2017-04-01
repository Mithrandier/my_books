Rails.application.routes.draw do
  root 'homepage#index'

  resources :authors, except: %i(show new edit)

  resources :editions, except: %i(new edit)

  resources :publishers, except: %i(show new edit)
end

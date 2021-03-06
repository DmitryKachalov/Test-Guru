Rails.application.routes.draw do

  root to: 'tests#index'

  devise_for :users, path: :gurus, path_names: { sign_in: :login, sign_out: :logout }
  #get 'sessions/new'
  #get 'users/new'

  resources :contacts, only: :create
  get 'contact-us', to: "contacts#new", as: "new_contact"

  resources :tests, only: :index do
    #resources :questions, shallow: true, except: :index do
     # resources :answers, shallow: true, except: :index
    # end
    member do
      post :start
    end
  end
  # GET /test_passages/101/result
  resources :test_passages, only: %i[show update] do
    member do
      get :result
      post :gist
    end
  end

  namespace :admin do
    resources :tests do
      patch :update_inline, on: :member

      resources :questions, shallow: true, except: :index do
        resources :answers, shallow: true, except: :index


      end
    end

    resources :gists, only: :index
  end


end

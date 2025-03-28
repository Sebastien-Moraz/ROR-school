Rails.application.routes.draw do
  get "home/index"
  resources :grades, except: [:index, :new, :create] do
    get 'report_card', on: :collection
  end
  resources :examinations do
    member do
      get 'manage_grades'
      post 'add_grade'
      patch 'update_grade/:grade_id', to: 'examinations#update_grade', as: 'update_grade'
      delete 'remove_grade/:grade_id', to: 'examinations#remove_grade', as: 'remove_grade'
    end
  end
  resources :courses do
    get 'calendar', on: :collection
  end
  resources :subjects
  resources :school_classes do
    member do
      get 'manage_students'
      post 'add_student'
      delete 'remove_student/:student_id', to: 'school_classes#remove_student', as: 'remove_student'
    end
  end
  resources :moments
  resources :rooms
  devise_for :people
  resources :people do
    get 'profile/edit', to: 'people#edit_profile', as: :edit_profile, on: :collection
    patch 'profile/update', to: 'people#update_profile', as: :update_profile, on: :collection
  end
  resources :addresses
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"
end

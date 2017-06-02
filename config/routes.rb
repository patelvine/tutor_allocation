Rails.application.routes.draw do

  namespace :admin do
    root "configuration#index"
    get "/calculate_tutors_required" => 'configuration#calculate_num_tutors', as: 'calculate_tutors_required'

    post "/hourly_rates" => "hourly_rates#update", as: "hourly_rates_update"
    post "/deadline" => "configuration#deadline", as: "deadline"
    post "/tutor_hours" => "configuration#tutor_hours", as: "tutor_hours"
    post "/course_hours" => "configuration#course_hours", as: "course_hours"
    post "/year_and_term" => "configuration#year_and_term", as: "year_and_term"
    put  "/import_courses" => "configuration#import_courses", as: "import_courses"
    resources :hourly_rates, only: [:index] do
    end
  end

  get 'courses/:id/export_course' => 'courses#export_course', :as => 'export_course'
  get 'courses/export_all_courses' => 'courses#export_all_courses', :as => 'export_all_courses'
  patch 'courses/:id/calculate_tutors' => 'courses#calculate_required_tutors', as: 'calculate_required_tutors'
  patch 'courses/:id/propose_course' => 'courses#propose_course', as: 'propose_course'
  patch 'courses/:id/finalise_accepted' => 'courses#finalise_accepted', as: 'finalise_accepted'
  get "/courses/:id/get_no_required_tutors" => 'courses#get_no_required_tutors', as: 'required_tutors'
  resources :courses, only: [:index, :show, :update]

  get "login" => "sessions#new", :as => "login"
  post 'login' => 'sessions#create', :as => 'post_session'

  get 'logout' => 'sessions#destroy', :as => 'logout'
  get 'signup' => 'users#new', :as => 'signup'

  resources :users, :only => [:create, :show]
  resources :sessions, :only => [:new, :create, :destroy]

  root "application#home_page"

  patch 'tutor_applications/:id/update_comment' => 'tutor_applications#update_comment', :as => 'update_comment'
  patch 'tutor_applications/:id/disqualify_tutor' => 'tutor_applications#disqualify_tutor', as: 'disqualify_tutor'

  get 'tutor_applications/:id/application_print' => 'tutor_applications#application_print', :as => 'print_application'
  get 'tutor_applications/export_finalised_tutors' => 'tutor_applications#export_finalised_tutors', :as => 'export_finalised_tutors'
  get 'tutor_applications/export_all_tutors' => "tutor_applications#export_all_tutors", :as => 'export_all_tutors'

  resources :tutor_applications, except: [:delete]
  get "/tutor_applications" => "tutor_applications#index", as: 'tutor_applications_filter'
  patch "/tutor_applications/:id/update_pay" => "tutor_applications#update_pay", as: 'tutor_application_update_pay'

  post "/allocation_link/:application_id" => "allocation_link#create", as: "create_allocation"
  put "/allocation_link/:id/update_state" => "allocation_link#update_state", as: "update_allocation_state"
  post "/accept/:id" => "allocation_link#accept", as: "accept_allocation"
  post "/reject/:id" => "allocation_link#reject", as: "reject_allocation"

  resources :allocation_link, only: [:destroy]

end

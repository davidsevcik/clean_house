CleanHouse::Application.routes.draw do

  get '/', to: redirect('/calendar/brno')

  get '/calendar/:place', to: 'shifts#index', as: 'calendar'
  get '/statistics/:place', to: 'shifts#statistics', as: 'statistics'

  resources :user_sessions
  resources :members
  resources :shifts do
    collection do
      post 'regenerate'
      get 'print'
      get 'statistics'
    end
  end
end

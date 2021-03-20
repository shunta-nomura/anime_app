Rails.application.routes.draw do
  root to: "blogs#index"
  resources :blogs do
    collection do
      get 'search'
    end
  end
end

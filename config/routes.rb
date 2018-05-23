Rails.application.routes.draw do
  get 'view/all'
  get 'view/:location', to: 'view#all'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/view/all', status: 301)
end

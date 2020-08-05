Rails.application.routes.draw do
  get 'view/all'
  get 'top_lists', to: 'view#top_lists'
  get 'view/:location', to: 'view#all'
  get 'about', to: 'view#about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: redirect('/view/all', status: 301)
end

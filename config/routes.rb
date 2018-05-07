Rails.application.routes.draw do
  get 'view/all'
  get 'view/eastbay'
  get 'view/fifelake'
  get 'view/interlochen'
  get 'view/kingsley'
  get 'view/peninsula'
  get 'view/traversecity'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'view#all'
end

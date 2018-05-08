Rails.application.routes.draw do
  get 'view/all'
  get 'view/eastbay'
  get 'view/fifelake'
  get 'view/interlochen'
  get 'view/kingsley'
  get 'view/peninsula'
  get 'view/traversecity'
  get 'view/collection'
  get 'view/circulation'
  get 'view/wireless'
  get 'view/pubcomp'
  get 'view/visitors'
  get 'view/questions'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'view#all'
end

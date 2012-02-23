TestDriven::Application.routes.draw do
  
  match '/home',    to: 'pages#home'
  match '/about',   to: 'pages#about'
  match '/contact', to: 'pages#contact'
  root :to => 'pages#home'
  
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#deploy', via: :post
  root 'main#index', via: :get
end

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#deploy', via: :post
  root 'application#status', via: :get
end

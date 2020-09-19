Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'get_exchange_rates', to: 'exchange_rates#get_exchange_rates'


end

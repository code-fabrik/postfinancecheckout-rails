Postfinancecheckout::Engine.routes.draw do
  post :webhook, to: 'webhooks#create'
end

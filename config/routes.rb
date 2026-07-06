Rails.application.routes.draw do
  get "/admin/sign_in", to: redirect("/users/sign_in?admin_login=1", status: 302), as: :sjma_admin_sign_in

  mount Decidim::Core::Engine => '/'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end

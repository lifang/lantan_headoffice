LantanHeadoffice::Application.routes.draw do

  # The priority is based upon order of creation:
  # first created -> highest priority.
  #  resources :stores do
  #    member do
  #      post :create
  #    end
  #    collection do
  #      get :show_store
  #      get :edit_store
  #    end
  #  end
  resources :complaints do
    collection do
      post :show_order_detail
    end
  end
  resources :revisits
  resources :pleaseds do
    collection do
      get :search_cities
    end
  end
  resources :products do
    collection do
      post "edit_prod","add_serv","add_prod","serv_create","load_material"
      get "prod_services"
    end
    member do
      post "edit_prod","update_prod","serv_update","edit_serv","show_prod","show_serv","prod_delete","serve_delete"
    end
  end
  resources :materials do
    collection do
      get :show_material_beizhu
      post :material_update
      get :show_material_order_beizhu
      post :material_order_update
      post :material_check
      get :mat_order_detail
      post :deliver_good
      get :urge_payment
      post :ruku
      get :m_list
    end
  end
  resources :authorities do
    collection do
      post :add_role
      get :del_role
      post :update_role
      get :set_auth
      post :set_auth_commit
      get :set_staff
      get :set_staff_role
      post :set_staff_role_commit
    end
  end
  resources :syncs do
    collection do
      post :upload_file
      get :is_generate_zip
    end
  end
  resources :news do
    collection do
      get :release
      get :detail
      post :update_new
    end
  end
  resources :cars do
    collection do
      post :new_brand
      get :check_model
      get :del_brand
      post :update_model
      get :del_model
      post :new_model
    end
  end
  resources :stores do
    collection do
      post :province_change
      post :new_store_select_province
      post :edit_store_select_province
    end
  end
  resources :sv_cards do
    collection do
      get :sell_situation
      post :search
      get :select_discount_card
      get :select_storeage_card
      get :search_products_all
      post :search_products_part
      post :make_billing
      post :situation_search
      get :use_detail
      get :use_collect
      get :new_card
      get :edit_card
      get :edit_search_products_all
      post :edit_search_products_part    
    end
    member do
      post :update
    end
  end
  resources :sales do
    collection do
      post :del_sale
      post :rel_sale
      post :search_product
      post :edit_search_product
      get :release
      get :edit
    end
    member do
      post :update
    end
  end
  resources :logins do
    member do
      post :create    
    end
    collection do
      get :logout
    end
  end
  resources :backstages
  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'logins#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  namespace :api do
    resources :materials do
      collection do
        get "search_material"
        post "save_mat_info","update_status"
      end
    end
    resources :syncs_datas do
      collection do
        post :syncs_db_to_all, :syncs_pics
      end
      member do
        get :return_sync_all_to_db
      end
    end
  end
end

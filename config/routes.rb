Compras::Application.routes.draw do
  resources :application_codes do
    collection do
      get :filter
      get :modal
    end
  end

  resources :contract_terminations, :except => [:show, :destroy]

  resources :creditors do
    collection do
      get :filter
      get :modal
    end
  end

  resources :fiscal_years do
    collection do
      get :filter
      get :modal
    end
  end

  resources :holidays do
    collection do
      get :filter
      get :modal
    end
  end

  resources :indexers do
    collection do
      get :filter
      get :modal
    end
  end

  resources :installment_terms do
    collection do
      get :modal
      get :filter
    end
  end

  namespace :iss_intel do
    post 'companies/sync'
    post 'individuals/sync'
  end

  # Keep routes sorted alphabetically
  root :to => 'bookmarks#show'

  devise_for :users, :controllers => { :confirmations => 'confirmations' }

  devise_scope :user do
    put '/confirm' => 'confirmations#confirm'
  end

  resource :account, :only => %w(edit update)

  resources :accountants do
    collection do
      get :modal
      get :filter
    end
  end

  resources :addresses

  resources :regulatory_acts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :administration_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :administrative_processes, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
  end

  resources :administrative_process_budget_allocation_items, :only => [] do
    collection do
      get :modal
    end
  end

  resources :administrative_process_liberations, :except => [ :destroy, :index, :update ]

  resources :agencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :supply_authorizations, :only => [:show, :modal] do
    collection do
      get :modal
    end
  end

  resources :banks do
    collection do
      get :modal
      get :filter
    end
  end

  resources :bank_accounts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :branch_activities do
    collection do
      get :modal
      get :filter
    end
  end

  resources :branch_classifications do
    collection do
      get :modal
      get :filter
    end
  end

  resource :bookmark do
    member do
      get :empty
    end
  end

  resources :budget_allocations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_allocation_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_revenues do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_structure_configurations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :budget_structures do
    collection do
      get :filter
      get :modal
    end
  end

  get 'budget_structure_levels/modal', :as => :modal_budget_structure_levels

  resources :capabilities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capability_allocation_details do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capability_destinations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :capability_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :company_sizes do
    collection do
      get :modal
      get :filter
    end
  end

  resources :contracts do
    resources :delivery_schedules

    collection do
      get :filter
      get :modal
      get :next_sequential
    end
  end

  resources :contract_termination_annuls, :only => [:new, :create, :edit, :update]

  resources :regulatory_act_type_classifications do
    collection do
      get :filter
      get :modal
    end
  end

  resources :classification_of_types_of_administractive_acts do
    collection do
      get :filter
      get :modal
    end
  end

  resources :cities do
    collection do
      get :modal
      get :filter
    end
  end

  resources :cnaes do
    collection do
      get :modal
      get :filter
    end
  end

  resources :communication_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :condominia do
    collection do
      get :modal
      get :filter
    end
  end

  resources :countries do
    collection do
      get :modal
      get :filter
    end
  end

  resources :currencies do
    collection do
      get :modal
      get :filter
    end
  end

  resources :debt_payment_resources, :only => %w(index)

  resources :delivery_locations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :descriptors do
    collection do
      get :filter
      get :modal
    end
  end

  resources :direct_purchases, :except => [:destroy, :show] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :districts do
    collection do
      get :modal
      get :filter
    end
  end

  resources :dissemination_sources do
    collection do
      get :filter
      get :modal
    end
  end

  resources :document_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :economic_registrations do
    collection do
      get :modal
      get :filter
    end
  end

  get 'expense_categories/modal', :as => :modal_expense_categories
  get 'expense_groups/modal', :as => :modal_expense_groups
  get 'expense_modalities/modal', :as => :modal_expense_modalities
  get 'expense_elements/modal', :as => :modal_expense_elements

  resources :expense_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :extra_credits do
    collection do
      get :filter
      get :modal
    end
  end

  resources :extra_credit_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :employees do
    collection do
      get :filter
      get :modal
    end
  end

  resources :entities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :expense_kinds do
    collection do
      get :filter
      get :modal
    end
  end

  resources :functions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :government_actions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :government_programs do
    collection do
      get :filter
      get :modal
    end
  end

  get "individuals/modal", :as => :modal_individuals

  resources :judgment_forms do
    collection do
      get :filter
      get :modal
    end
  end

  resources :judgment_commission_advices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :land_subdivisions do
    collection do
      get :modal
      get :filter
    end
  end

  resources :legal_natures, :only => [:index, :edit] do
    collection do
      get :modal
    end
  end

  resources :legal_references do
    collection do
      get :filter
      get :modal
    end
  end

  resources :legal_text_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_commissions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_modalities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_notices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_objects do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_appeals do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_impugnments do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_ratifications, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
  end

  get 'licitation_processes/new/:administrative_process_id', :controller => :licitation_processes, :action => :new, :as => :new_licitation_process

  resources :licitation_processes, :except => [ :destroy, :new ] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_bidders do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_lots do
    collection do
      get :filter
      get :modal
    end
  end

  resources :licitation_process_publications do
    collection do
      get :filter
      get :modal
    end
  end

  resources :macro_objectives do
    collection do
      get :filter
      get :modal
    end
  end

  resources :management_units do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials_classes do
    collection do
      get :filter
      get :modal
    end
  end

  resources :materials_groups do
    collection do
      get :filter
      get :modal
    end
  end

  resources :modality_limits do
    collection do
      get :filter
      get :modal
    end
  end

  resources :moviment_types do
    collection do
      get :modal
      get :filter
    end
  end

  resources :neighborhoods do
    collection do
      get :modal
      get :filter
    end
  end

  get 'occupation_classifications/modal', :as => :modal_occupation_classifications

  resources :payment_methods do
    collection do
      get :filter
      get :modal
    end
  end

  resources :parcels do
    collection do
      get :filter
    end
  end

  resources :people do
    collection do
      get :modal
      get :filter
    end
  end

  resources :occurrence_contractual_historics do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_categories do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_historics do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_cancellations, :except => [:destroy, :update] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledge_liquidation_annuls, :except => [:destroy, :update]

  resources :pledge_liquidations, :except => [:destroy, :update] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :pledges, :except => [:destroy, :update] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :positions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :precatories do
    collection do
      get :filter
      get :modal
    end
  end

  resources :precatory_types do
    collection do
      get :filter
      get :modal
    end
  end

  resource :prefecture, :except => :destroy

  resources :price_collections, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
  end

  get 'price_collections/:price_collection_id/price_collection_proposals' => 'price_collection_proposals#index', :as => :price_collection_price_collection_proposals

  resources :price_collection_proposals, :only => [:index, :edit, :update] do
    collection do
      get :modal
    end
  end

  resources :price_collection_annuls, :except => [:index, :show, :destroy]

  resources :price_collection_proposal_annuls, :except => [:index, :show, :destroy]

  resources :products do
    collection do
      get :modal
      get :filter
    end
  end

  resources :profiles do
    collection do
      get :modal
      get :filter
    end
  end

  resources :program_kinds do
    collection do
      get :modal
      get :filter
    end
  end

  resources :property_variable_setting_options, :only => :index

  resources :purchase_solicitations, :except => :destroy do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_solicitation_annuls, :only => [:new, :create, :edit, :update]

  resources :purchase_solicitation_item_groups do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_solicitation_item_group_materials do
    collection do
      get :filter
      get :modal
    end
  end

  resources :purchase_solicitation_liberations, :only => [:index, :new, :create, :edit] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reference_units do
    collection do
      get :modal
      get :filter
    end
  end

  resources :registration_cadastral_certificates do
    collection do
      get :modal
      get :filter
    end
  end

  resources :registration_terms do
    collection do
      get :modal
      get :filter
    end
  end

  resources :regularization_or_administrative_sanction_reasons do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reserve_allocation_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reserve_funds, :except => [:destroy, :update] do
    collection do
      get :filter
      get :modal
    end
  end

  resources :reserve_fund_annuls, :except => [:destroy, :update]

  get 'revenue_rubrics/modal', :as => :modal_revenue_rubrics
  get 'revenue_sources/modal', :as => :modal_revenue_sources
  get 'revenue_subcategories/modal', :as => :modal_revenue_subcategories
  get 'revenue_categories/modal', :as => :modal_revenue_categories

  resources :revenue_natures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :risk_degrees do
    collection do
      get :modal
      get :filter
    end
  end

  resources :service_or_contract_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :side_streets do
    collection do
      get :modal
    end
  end

  resources :signature_configurations do
    collection do
      get :filter
      get :modal
    end
  end

  resources :signatures do
    collection do
      get :filter
      get :modal
    end
  end

  resources :states do
    collection do
      get :modal
      get :filter
    end
  end

  resources :street_types do
    collection do
      get :modal
      get :filter
    end
  end

  resources :streets do
    collection do
      get :modal
      get :filter
    end
  end

  resources :settings, :only => %w(index edit update) do
    collection do
      get :filter
    end
  end

  resources :subfunctions do
    collection do
      get :filter
      get :modal
    end
  end

  resources :target_audiences do
    collection do
      get :filter
      get :modal
    end
  end

  resources :tce_specification_capabilities do
    collection do
      get :filter
      get :modal
    end
  end

  resources :type_improvements do
    collection do
      get :modal
    end
  end

  resources :record_prices do
    collection do
      get :filter
      get :modal
    end
  end

  resources :regulatory_act_types do
    collection do
      get :filter
      get :modal
    end
  end

  resources :users do
    collection do
      get :filter
    end
  end
end

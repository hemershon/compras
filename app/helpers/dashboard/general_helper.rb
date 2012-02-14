module Dashboard::GeneralHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.employees
      m.countries
      m.states
      m.communication_sources
      m.organogram_configurations
      m.cities
      m.districts
      m.dissemination_sources
      m.economic_classification_of_expenditures
      m.neighborhoods
      m.streets
      m.street_types
      m.land_subdivisions
      m.condominiums
      m.condominium_types
      m.people
      m.banks
      m.agencies
      m.bank_accounts
      m.prefectures
      m.service_or_contract_types
      m.settings
      m.fiscal_years
      m.reference_units
      m.delivery_locations
      m.materials_groups
      m.materials_classes
      m.materials
      m.organograms
      m.type_of_administractive_acts
      m.entities
      m.administractive_acts
      m.administration_types
      m.budget_allocations
      m.purchase_solicitations
      m.legal_natures
      m.legal_text_natures
      m.currencies
      m.stn_ordinances
      m.cnaes
    end
  end
end

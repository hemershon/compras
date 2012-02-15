module Dashboard::GeneralHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.employees
      m.countries
      m.states
      m.cities
      m.districts
      m.dissemination_sources
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
      m.entities
      m.legal_natures
      m.currencies
      m.stn_ordinances
      m.cnaes
      m.risk_degrees
    end
  end
end

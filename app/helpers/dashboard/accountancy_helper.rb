module Dashboard::AccountancyHelper
  def content_classes
    "dashboard"
  end

  def links
    simple_menu do |m|
      m.organogram_configurations
      m.organograms
      m.classification_of_types_of_administractive_acts
      m.type_of_administractive_acts
      m.administractive_acts
      m.administration_types
      m.budget_allocations
      m.legal_text_natures
    end
  end
end

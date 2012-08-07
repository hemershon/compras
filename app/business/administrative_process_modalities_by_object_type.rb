class AdministrativeProcessModalitiesByObjectType
  attr_accessor :modality, :object_type

  def initialize(modality = AdministrativeProcessModality, object_type = AdministrativeProcessObjectType)
    self.modality = modality
    self.object_type = object_type
  end

  def modalities_groups
    {
      object_type::PURCHASE_AND_SERVICES => [
        modality::MAKING_COST_FOR_PURCHASES_AND_SERVICES,
        modality::INVITATION_FOR_PURCHASES_AND_ENGINEERING_SERVICES,
        modality::PRESENCE_TRADING,
        modality::ELECTRONIC_TRADING,
        modality::EXEMPTION_FOR_PURCHASES_AND_SERVICES,
        modality::UNENFORCEABILITY
      ],
      object_type::CONSTRUCTION_AND_ENGINEERING_SERVICES => [
        modality::MAKING_COST_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
        modality::INVITATION_FOR_CONSTRUCTIONS_ENGINEERING_SERVICES,
        modality::COMPETITION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
        modality::ELECTRONIC_TRADING,
        modality::EXEMPTION_FOR_CONSTRUCTIONS_AND_ENGINEERING_SERVICES,
        modality::UNENFORCEABILITY,
        modality::COMPETITION,
        modality::PRESENCE_TRADING
      ],
      object_type::DISPOSALS_OF_ASSETS => [
        modality::AUCTION,
        modality::PRESENCE_TRADING
      ],
      object_type::CONCESSIONS_AND_PERMITS => [
        modality::COMPETITION_FOR_GRANTS
      ],
      object_type::CALL_NOTICE => [
        modality::COMPETITION,
      ]
    }
  end

  def verify_modality(object_type, modality)
    modalities_groups[object_type].include?(modality)
  end
end

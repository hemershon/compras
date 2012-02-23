ManagementUnit.blueprint(:unidade_central) do
  description { "Unidade Central" }
  acronym { "UGC" }
  status { "active" }
  year { "2012" }
  entity { Entity.make!(:detran) }
end

ManagementUnit.blueprint(:unidade_auxiliar) do
  description { "Unidade Auxiliar" }
  acronym { "UAC" }
  status { "active" }
  year { "2013" }
  entity { Entity.make!(:detran) }
end

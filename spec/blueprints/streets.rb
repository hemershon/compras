# encoding: utf-8

Street.blueprint(:amazonas) do
  name        { "Amazonas" }
  street_type { StreetType.make!(:avenida) }
  tax_zone    { "2" }
  city { City.make!(:porto_alegre) }
  neighborhoods { [Neighborhood.make!(:portugal)] }
end

Street.blueprint(:girassol) do
  name        { "Girassol" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { City.make!(:belo_horizonte) }
  neighborhoods { [Neighborhood.make!(:centro), Neighborhood.make!(:sao_francisco_bh)] }
end

Street.blueprint(:girassol_curitiba) do
  name        { "Girassol" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { City.make!(:curitiba) }
  neighborhoods { [Neighborhood.make!(:sao_francisco)] }
end

Street.blueprint(:bento_goncalves) do
  name        { "Bento Gonçalves" }
  street_type { StreetType.make!(:rua) }
  tax_zone    { "2" }
  city { City.make!(:porto_alegre) }
  neighborhoods { [Neighborhood.make!(:portugal)] }
end

Street.blueprint(:cristiano_machado) do
  name        { "Cristiano Machado" }
  street_type { StreetType.make!(:avenida) }
  tax_zone    { "2" }
  city { City.make!(:belo_horizonte) }
  neighborhoods { [Neighborhood.make!(:centro)] }
end

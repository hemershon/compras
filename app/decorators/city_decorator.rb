class CityDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :name, :state, :code, :to_s => false, :link => :name
end

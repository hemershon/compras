# encoding: utf-8
class RevenueNatureImporter < Importer
  attr_accessor :repository, :revenue_category_repository
  attr_accessor :revenue_subcategory_repository, :revenue_source_repository
  attr_accessor :revenue_rubric_repository, :code_generator

  def initialize(repository = RevenueNature, revenue_category_repository = RevenueCategory, revenue_subcategory_repository = RevenueSubcategory, revenue_source_repository = RevenueSource, revenue_rubric_repository = RevenueRubric, code_generator = RevenueNatureCodeGenerator)
    self.repository                     = repository
    self.revenue_category_repository    = revenue_category_repository
    self.revenue_subcategory_repository = revenue_subcategory_repository
    self.revenue_source_repository      = revenue_source_repository
    self.revenue_rubric_repository      = revenue_rubric_repository
    self.code_generator              = code_generator
  end

  def import!
    transaction do
      parser.foreach(file, options) do |row|
        revenue_nature = repository.new(normalize_attributes(row.to_hash))
        code_generator.new(revenue_nature).generate!
        revenue_nature.save(:validate => false)
      end
    end
  end

  protected

  def normalize_attributes(attributes)
    category_code    = attributes['code'][0]
    subcategory_code = attributes['code'][1]
    source_code      = attributes['code'][2]
    rubric_code      = attributes['code'][3]
    classification   = attributes['code'][4..7]

    category    = revenue_category_repository.where(:code => category_code).first
    subcategory = revenue_subcategory_repository.where(:code => subcategory_code, :revenue_category_id => category.try(:id)).first
    source      = revenue_source_repository.where(:code => source_code, :revenue_subcategory_id => subcategory.try(:id)).first
    rubric      = revenue_rubric_repository.where(:code => rubric_code, :revenue_source_id => source.try(:id)).first

    attributes.merge(
      'revenue_category_id' => category.try(:id),
      'revenue_subcategory_id' => subcategory.try(:id),
      'revenue_source_id' => source.try(:id),
      'revenue_rubric_id' => rubric.try(:id),
      'classification' => classification,
      'kind' => kind(attributes)
    ).except('status', 'code').reject { |key| key.blank? }
  end

  def kind(attributes)
    case attributes['kind']
    when 'A'
      'analytical'
    when 'S'
      'synthetic'
    end
  end

  def file
    'lib/import/files/revenue_natures.csv'
  end
end

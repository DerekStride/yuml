# Represents a yUML Class
class YUMLClass
  attr_writer :name

  def initialize
    @methods = []
    @variables = []
    @relationships = []
  end

  def name(name = nil)
    @name = name if name
    @name
  end

  def method_missing(id, *args, &block)
    scope = '+'
    scope = '-' if id.to_s.include?('private')
    options = { scope: scope }
    if id.to_s.include?('variable')
      uml_attributes(options.merge(attribute: :variables), *args, &block)
    elsif id.to_s.include?('method')
      uml_attributes(options.merge(attribute: :methods), *args, &block)
    else
      super
    end
  end

  def has_a(dest, options = {})
    relationship = YUMLRelationship.relationship(options)
    @relationships << "[#{name}]#{relationship}[#{dest.name}]"
  end

  def is_a(dest, options = {})
    relationship = YUMLRelationship.relationship(options)
    @relationships << "[#{dest.name}]#{relationship}[#{name}]"
  end

  def to_s
    relate = ", #{@relationships.join(', ')}" unless @relationships.empty?
    "[#{name}#{variables}#{methods}]#{relate}"
  end

  private

  def uml_attributes(options, *args)
    if options.fetch(:attribute) == :variables
      uml_variables(options, *args)
    elsif options.fetch(:attribute) == :methods
      uml_methods(options, *args)
    end
  end

  def uml_variables(options, *args)
    args.each { |var| variable(scope: options[:scope], attribute: var) }
  end

  def uml_methods(options, *args)
    args.each do |m|
      met = if m.class == Hash
              m.map { |k, v| "#{k}(#{v.join(', ')})" }.join(';')
            else
              "#{m}()"
            end
      method(scope: options[:scope], attribute: met)
    end
  end

  def method(options)
    attribute(@methods, options)
  end

  def variable(options)
    attribute(@variables, options)
  end

  def attribute(attributes, options)
    scope = options[:scope] || '+'
    scope = '+' unless %w(+ -).include?(scope)
    attributes << "#{scope}#{options.fetch(:attribute)}"
  end

  def methods
    attributes(@methods)
  end

  def variables
    attributes(@variables)
  end

  def attributes(attrs)
    "|#{attrs.join(';')}" unless attrs.empty?
  end
end

# Represents a yUML relationship
module YUMLRelationship
  extend self

  def relationship(options)
    options = { type: :aggregation }.merge(options)
    types = %i(aggregation composition inheritance interface)
    type = options[:type]
    type = :aggregation unless types.include?(type)
    cardinality = options[:cardinality]
    representation(type, cardinality)
  end

  private

  def representation(type, cardinality)
    if %i(aggregation composition).include?(type)
      return composition(type, cardinality)
    elsif %i(inheritance interface).include?(type)
      return inheritance(type)
    end
  end

  def composition(type, cardinality)
    base = '+'
    base << '+' if type == :composition
    if cardinality.nil?
      base << '->'
    elsif cardinality.class == Array && cardinality.length == 2
      base << "#{cardinality[0]}-#{cardinality[1]}>"
    else
      base << "-#{cardinality}>"
    end
    base
  end

  def inheritance(type)
    return '^-.-' if type == :interface
    '^-'
  end
end

# Fetches UML from yUML
class YUML
  def initialize
  end

  def class
    y = YUMLClass.new
    yield y
    y
  end
end
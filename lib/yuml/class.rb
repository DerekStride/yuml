module YUML
  # Represents a yUML Class
  class Class
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

    def public_methods(*args)
      uml_methods('+', *args)
    end

    def private_methods(*args)
      uml_methods('-', *args)
    end

    def public_variables(*args)
      uml_variables('+', *args)
    end

    def private_variables(*args)
      uml_variables('-', *args)
    end

    def has_a(dest, options = {})
      relationship = YUML::Relationship.relationship(options)
      @relationships << "[#{name}]#{relationship}[#{dest.name}]"
    end

    def is_a(dest, options = {})
      options[:type] = :inheritance unless %i(inheritance interface).include?(options[:type])
      relationship = YUML::Relationship.relationship(options)
      @relationships << "[#{dest.name}]#{relationship}[#{name}]"
    end

    def to_s
      relate = ", #{@relationships.join(', ')}" unless @relationships.empty?
      "[#{name}#{variables}#{methods}]#{relate}"
    end

    private

    def uml_variables(scope, *args)
      args.each { |var| variable(scope: scope, attribute: var) }
    end

    def uml_methods(scope, *args)
      args.each do |m|
        met = if m.class == Hash
                m.map { |k, v| "#{k}(#{v.join(', ')})" }.join(';')
              else
                "#{m}()"
              end
        method(scope: scope, attribute: met)
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
end

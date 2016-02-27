module YUML
  # Represents a yUML Class
  class Class
    attr_writer :name, :interface

    def initialize
      @methods = []
      @variables = []
      @relationships = []
    end

    def name(name = nil)
      @name = name if name
      "#{normalized_interface}#{@name}"
    end

    def interface(interface = nil)
      @interface = interface if interface
      @interface
    end

    def variables(*args)
      args.flatten!
      return attributes(@variables) if args.empty?
      @variables << normalize(args)
    end

    def methods(*args)
      args.flatten!
      return attributes(@methods) if args.empty?
      @methods << normalize(args)
    end

    def has_a(dest, options = {})
      options[:type] = :aggregation unless %i(composition aggregation).include?(options[:type])
      relationship = YUML::Relationship.send(options[:type], options[:cardinality])
      @relationships << "[#{name}]#{relationship}[#{dest.name}]"
    end

    def is_a(dest, options = {})
      options[:type] = :inheritance unless %i(inheritance interface).include?(options[:type])
      relationship = YUML::Relationship.send(options[:type])
      @relationships << "[#{dest.name}]#{relationship}[#{name}]"
    end

    def associated_with(dest, options = {})
      options[:type] = :directed_assoication unless %i(
        association directed_assoication two_way_association dependency
      ).include?(options[:type])
      relationship = YUML::Relationship.send(options[:type], options[:cardinality])
      @relationships << "[#{name}]#{relationship}[#{dest.name}]"
    end

    def attach_note(content, options = {})
      @relationships << "[#{name}]-#{YUML::Note.create(content, options)}"
    end

    def to_s
      "[#{name}#{variables}#{methods}]"
    end

    def relationships
      "#{@relationships.join(',')}" unless @relationships.empty?
    end

    private

    def normalize(values)
      values.map(&:to_s).map do |v|
        YUML::ESCAPE_CHARACTERS.each { |char, escape| v.tr!(char, escape) }
        v
      end
    end

    def normalized_interface
      name interface unless @name
      return normalize(['<<interface>>']).first << ';' if interface
    end

    def attributes(attrs)
      "|#{attrs.join(';')}" unless attrs.empty?
    end
  end
end

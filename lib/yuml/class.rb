module YUML
  # Represents a yUML Class
  class Class
    attr_writer :name

    def initialize
      @methods = []
      @variables = []
      @relationships = []
    end

    def name(name = nil, prototype = nil)
      @name = name if name
      @prototype = prototype if prototype
      "#{normalized_prototype}#{@name}"
    end

    def name=(*args)
      args.flatten!
      @name = args.first
      @prototype = args.pop if args.size > 1
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

    def has_a(dest, type: :aggregation, cardinality: nil, association_name: cardinality)
      cardinality ||= association_name
      type = :aggregation unless %i(composition aggregation).include?(type)
      relationship = YUML::Relationship.send(type, cardinality)
      @relationships << "[#{name}]#{relationship}[#{dest.name}]"
    end

    def is_a(dest, type: :inheritance)
      type = :inheritance unless %i(inheritance interface).include?(type)
      relationship = YUML::Relationship.send(type)
      @relationships << "[#{dest.name}]#{relationship}[#{name}]"
    end

    def associated_with(dest, type: :directed_assoication, cardinality: nil, association_name: cardinality)
      cardinality ||= association_name
      type = :directed_assoication unless %i(
        association directed_assoication two_way_association dependency
      ).include?(type)
      relationship = YUML::Relationship.send(type, cardinality)
      @relationships << "[#{name}]#{relationship}[#{dest.name}]"
    end

    def attach_note(content, color = nil)
      @relationships << "[#{name}]-#{YUML::Note.create(content, color)}"
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

    def normalized_prototype
      return normalize(["<<#{@prototype}>>"]).first << ';' if @prototype
    end

    def attributes(attrs)
      "|#{attrs.join(';')}" unless attrs.empty?
    end
  end
end

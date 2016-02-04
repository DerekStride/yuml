# Represents a yUML relationship
module YUML
  module Relationship
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
end

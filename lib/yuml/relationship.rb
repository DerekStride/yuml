module YUML
  # Represents UML class relationships
  module Relationship
    module_function

    def inheritance
      '^-'
    end

    def interface
      '^-.-'
    end

    def composition(*args)
      "++#{association(*args)}>"
    end

    def aggregation(*args)
      "+#{association(*args)}>"
    end

    def two_way_association(*args)
      "<#{association(*args)}>"
    end

    def directed_assoication(*args)
      "#{association(*args)}>"
    end

    def association(*args)
      args.flatten!
      return "-#{args.first}" if args.size == 1
      "#{args.first}-#{args.last}"
    end

    def dependency(*args)
      args.flatten!
      return "-.-#{args.first}>" if args.size == 1
      "#{args.first}-.-#{args.last}>"
    end
  end
end

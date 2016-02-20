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
      "+#{aggregation(*args)}"
    end

    def aggregation(*args)
      args.flatten!
      if args.size == 2
        "+#{args[0]}-#{args[1]}>"
      elsif args.size == 1
        "+-#{args.first}>"
      else
        '+->'
      end
    end
  end
end

module YUML
  # Represents a yUML Note
  module Note
    module_function

    def create(body, color: 'cornsilk')
      "[note: #{body}{bg:#{color || 'cornsilk'}}]"
    end
  end
end

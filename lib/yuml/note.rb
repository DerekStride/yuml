module YUML
  # Represents a yUML Note
  module Note
    module_function

    def create(body, options = {})
      color = options[:color] || 'cornsilk'
      "[note: #{body}{bg:#{color}}]"
    end
  end
end

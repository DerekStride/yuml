# Fetches UML from yUML
require_relative 'yuml/class'
require_relative 'yuml/relationship'

module YUML
  def generate_class
    y = YUML::Class.new
    yield y
    y
  end

  module_function :generate_class
end

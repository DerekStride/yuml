# Fetches UML from yUML
require_relative 'yuml_generator/yuml_class'
require_relative 'yuml_generator/yuml_relationship'

module YUML
  def generate_class
    y = YUML::Class.new
    yield y
    y
  end

  module_function :generate_class
end

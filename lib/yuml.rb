# Fetches UML from yUML
require 'net/http'
require 'yuml/class'
require 'yuml/relationship'

module YUML
  extend self

  ESCAPE_CHARACTERS = {
    '{' => "\u23A8",
    '}' => "\u23AC"
  }

  ESCAPE_COMMA = "\u201A"

  def generate(options)
    options = { file: '/tmp/yuml.pdf' }.merge(options)
    classes.clear
    yield self
    fetch_uml options[:file]
  end

  def class(&block)
    yuml_class = YUML::Class.new
    block.arity < 1 ? yuml_class.instance_eval(&block) : block.call(yuml_class)
    classes << yuml_class
    yuml_class
  end

  private

  def classes
    @classes ||= []
  end

  def yuml
    uml = classes.map(&:to_s).join(',')
    relationships = classes.map(&:relationships).compact
    uml << ',' << relationships.join(',') unless relationships.empty?
    URI.encode(uml, encodings)
  end

  def fetch_uml(file)
    uri = URI("http://yuml.me/diagram/class/#{yuml}.pdf")
    response = Net::HTTP.get_response(uri)
    File.write(file, response.body)
  end

  def encodings
    "#{ESCAPE_CHARACTERS.values.join}#{ESCAPE_COMMA}[](){}+->|.,=;*^ "
  end
end

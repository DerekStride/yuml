# Fetches UML from yUML
require 'net/http'
require_relative 'yuml/class'
require_relative 'yuml/relationship'

module YUML
  def generate(&block)
    yield YUML
  end

  def class(&block)
    yuml_class = YUML::Class.new
    block.arity < 1 ? yuml_class.instance_eval(&block) : block.call(yuml_class)
    yuml_class
  end

  def fetch_uml(yuml)
    yuml = URI.encode_www_form_component(yuml)
    uri = URI("http://yuml.me/diagram/class/#{yuml}.pdf")
    response = Net::HTTP.get_response(uri)
    File.write('tmp.pdf', response.body)
  end

  module_function :generate, :class, :fetch_uml
end

# doc = YUML.generate_class do
#   name 'Document'
#   private_variables(:attribute)
#   public_methods(do_stuff: ['things'])
# end
#
# s = '[Document|-attribute|+do_stuff(things)]'
#
# pic = YUML.generate_class do
#   name 'Picture'
#   public_variables :bam
#   private_methods :bite_me
# end
#
# content = YUML.generate_class do
#   name 'Content'
#   public_methods :add
# end
#
# doc.is_a(content)
# pic.is_a(content)
# doc.has_a(pic)
#
# YUML.fetch_uml("#{doc}, #{pic}, #{content}")

# yuml

A Ruby DSL for generating UML built on yuml.me

## Getting Started

To build a UML document start with this block of code. Everything inside the block will be used to descibe the uml document you want to create.

```ruby
YUML.generate(file: 'tmp.pdf) do |uml|
  ...
end
```

### Generating a Class

To generate a class for the document use `uml.class` and pass a code block in to configure it. It accepts the following methods for configuration.

* name (required)
* variables
* methods

#### Example

```ruby
document = uml.class do
  name 'Document'
  variables '-title: String', '-body: String'
  methods(
    '+add_section(id: int, content: String, style: Symbol)',
    '+remove_section(id: int)',
    '+edit_section(id: int, content: String, style: Symbol)'
  )
end
```

### Adding Relationships

After generating some classes to add relationships to them use the following `YUML::Class` methods.

* `has_a(node, options = {})`
* `is_a(node, options = {})`

`has_a` defaults to aggregation and `is_a` defaults to inheritance.

#### Example

```ruby
document.has_a(picture, cardinality: '0..*')
document.is_a(content)

picture.is_a(content, type: :interface)
```

### Test it Out

```ruby
require 'yuml'

YUML.generate(file: 'example.pdf') do |uml|
  document = uml.class do
    name 'Document'
    variables '-title: String', '-body: String'
    methods(
      '+add_section(id: int, content: String, style: Symbol)',
      '+remove_section(id: int)',
      '+edit_section(id: int, content: String, style: Symbol)'
    )
  end

  picture = uml.class do
    name 'Picture'
  end

  content = uml.class do
    name 'Content'
  end

  document.has_a(picture, cardinality: '0..*')
  document.is_a(content)

  picture.is_a(content)
end
```

![output](https://cloud.githubusercontent.com/assets/6456191/13322710/bc91e81c-dba3-11e5-88d3-16e1980f7cb4.png)

#!/usr/bin/ruby

load 'scripts/wrap_enums.rb'

Dir.glob("src/*").each { |filename|
    text = File.read(filename)
    text = wrap_enums(text)
    File.open(filename, "w") { |f| f.write(text) }
}

generate_enum_property_wrapper

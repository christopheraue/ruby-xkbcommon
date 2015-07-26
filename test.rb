$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'xkbcommon'

keymap = Xkbcommon::Context.new.keymap_from_names(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')

puts "MODIFIERS"
puts keymap.modifiers.map{ |mod| "#{mod.name}: #{mod.keys.map(&:code)}" }
puts
puts "SYMBOLS"
puts keymap.characters.map{ |symbol, keys| "#{symbol} #{keys.map(&:name)}: #{keys.map(&:code)}" }
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib'))
require 'bundler/setup'
require 'xkbcommon'

keymap = Xkbcommon::Context.new.keymap_from_names(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')

def format_keys(keys)
  keys.map{ |key| "#{key.name}(#{key.scan_code})" }
end

puts "KEYS"
puts format_keys(keymap.keys)
puts
puts "MODIFIERS"
puts keymap.modifiers.map{ |mod| "#{mod.name}: #{format_keys(mod.keys).join(' + ')}" }
puts
puts "SYMBOLS"
puts keymap.symbols.map{ |symbol_name, symbol| "#{symbol_name}: #{format_keys(symbol.keys).join(' + ')}" }
puts
puts "CHARACTERS"
puts keymap.characters.map{ |char, symbol| "#{char} #{char.bytes}: #{format_keys(symbol.keys).join(' + ')}" }
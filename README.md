# Xkbcommon

xkbcommon bindings for ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xkbcommon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xkbcommon

## Usage

```ruby
require 'xkbcommon'

keymap = Xkbcommon::Context.new.keymap_from_names(rules: 'evdev', model: 'pc104', layout: 'de', variant: 'nodeadkeys')

# Available keys in keymap
keymap.keys                 # => [ #<Xkbcommon::Key>, #<Xkbcommon::Key>, ... ]

# Xkbcommon::Key interface
key = keymap.keys.find{ |key| key.name == :A }
key.name                    # => :A
key.scan_code               # => 30
key.code                    # => 38


# Available modifiers in keymap
keymap.modifiers            # => [ #<Xkbcommon::Modifier>, #<Xkbcommon::Modifier>, ... ]

# Xkbcommon::Modifier interface
mod = keymap.modifiers.first
mod.name                    # => :Shift
mod.index                   # => 0
mod.keys.map(&:name)        # => [:LEFTSHIFT], keys activating the modifier


# Available symbols in keymap
keymap.symbols              # => { :Escape => #<Xkbcommon::Symbol>, :"1" => #<Xkbcommon::Symbol>, ... }

# Xkbcommon::Symbol interface
sym = keymap.symbols[:A]
sym.keysym                  # => 65
sym..keys.map(&:name)       # => [:LEFTSHIFT, :A], keys producing the symbol
sym.name                    # => :A
sym.character               # => "A"


# Available characters in keymap
keymap.characters           # => { "\e" => #<Xkbcommon::Symbol>, "1" => #<Xkbcommon::Symbol>, ... }

# Xkbcommon::Symbol interface (see above)
```
require 'forwardable'

module Xkbcommon
  class Keymap
    extend Forwardable

    class << self
      def finalize(native)
        Proc.new { Libxkbcommon.xkb_keymap_unref(native) }
      end
    end

    def initialize(context, keymap)
      @context = context
      @to_native = keymap
      @parser = Parser.new(self)

      ObjectSpace.define_finalizer(self, self.class.finalize(to_native))
    end

    attr_reader :context, :to_native
    delegate [:keys, :modifiers, :symbols, :characters] => :@parser

    def to_s(format: Libxkbcommon::XKB_KEYMAP_USE_ORIGINAL_FORMAT)
      Libxkbcommon.xkb_keymap_get_as_string(to_native, format)
    end

    def inspect
      "#<#{self.class.name}:0x#{'%014x' % __id__} @producible_characters=#{characters.keys}>"
    end
  end
end
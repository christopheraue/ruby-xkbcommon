module Xkbcommon
  class Symbol
    def initialize(keymap, keysym)
      @keymap, @keysym = keymap, keysym
    end

    attr_reader :keymap, :keysym, :keys

    def keys=(keys)
      return if @keys
      @keys = [*keys].freeze
    end

    def name
      @name ||= begin
        char_size = 64
        char = FFI::MemoryPointer.new(:char, char_size)
        Libxkbcommon.xkb_keysym_get_name(@keysym, char, char_size)
        char.read_string.to_sym
      end
    end

    def character
      @character ||= begin
        char_size = 8
        char = FFI::MemoryPointer.new(:char, char_size)
        Libxkbcommon.xkb_keysym_to_utf8(@keysym, char, char_size)
        char.read_string.force_encoding('UTF-8')
      end
    end
  end
end
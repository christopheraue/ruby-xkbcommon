module Xkbcommon
  class Keymap
    class << self
      def finalize(native)
        Libxkbcommon.xkb_keymap_unref(native)
      end
    end

    def initialize(context, keymap)
      @context = context
      @to_native = keymap

      ObjectSpace.define_finalizer(self, self.class.finalize(to_native))
    end

    attr_reader :context, :to_native

    def to_s(format: Libxkbcommon::XKB_KEYMAP_USE_ORIGINAL_FORMAT)
      Libxkbcommon.xkb_keymap_get_as_string(to_native, format)
    end

    def keys
      @keys ||= begin
        min_code = Libxkbcommon.xkb_keymap_min_keycode(to_native)
        max_code = Libxkbcommon.xkb_keymap_max_keycode(to_native)
        codes = (min_code..max_code).select do |code|
          0 < Libxkbcommon.xkb_keymap_num_layouts_for_key(to_native, code)
        end
        codes.map{ |code| Key.new(self, code) }
      end
    end

    def modifiers
      @modifiers ||= (0..Libxkbcommon.xkb_num_mods(to_native)-1).map do |mod_idx|
        Modifier.new(self, mod_idx)
      end
    end
  end
end
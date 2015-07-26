module Xkbcommon
  class State
    class << self
      def finalize(native)
        Proc.new { Libxkbcommon.xkb_state_unref(native) }
      end
    end

    def initialize(keymap)
      @keymap = keymap
      @to_native = Libxkbcommon.xkb_state_new(keymap.to_native)

      ObjectSpace.define_finalizer(self, self.class.finalize(to_native))
    end

    attr_reader :keymap, :to_native

    def update_mask(depressed_mods: 0,
                    latched_mods: 0,
                    locked_mods: 0,
                    depressed_layout: 0,
                    latched_layout: 0,
                    locked_layout: 0)
      Libxkbcommon.xkb_state_update_mask(to_native, depressed_mods, latched_mods, locked_mods,
        depressed_layout, latched_layout, locked_layout)
    end

    def press_key(key)
      Libxkbcommon.xkb_state_update_key(to_native, key.code, Libxkbcommon::XKB_KEY_DOWN)
    end

    def press_keys(keys)
      keys.map{ |key| press_key(key) }.last
    end

    def release_key(key)
      Libxkbcommon.xkb_state_update_key(to_native, key.code, Libxkbcommon::XKB_KEY_UP)
    end

    def release_keys(keys)
      keys.map{ |key| release_key(key) }.last
    end

    def utf8_of_key(key)
      utf8_size = 8
      utf8 = FFI::MemoryPointer.new(:char, utf8_size)
      Libxkbcommon.xkb_state_key_get_utf8(to_native, key.code, utf8, utf8_size)
      utf8.read_string
    end

    def symbol_for_key(key)
      Libxkbcommon.xkb_state_key_get_one_sym(to_native, key.code)
    end

    def modifier_active?(modifier)
      0 < Libxkbcommon.xkb_state_mod_index_is_active(to_native, modifier.index, Libxkbcommon::XKB_STATE_MODS_EFFECTIVE)
    end
  end
end
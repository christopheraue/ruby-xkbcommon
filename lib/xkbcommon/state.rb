module Xkbcommon
  class State
    class << self
      def finalize(native)
        Libxkbcommon.xkb_state_unref(native)
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
      0 != Libxkbcommon.xkb_state_update_mask(to_native, depressed_mods, latched_mods, locked_mods,
        depressed_layout, latched_layout, locked_layout)
    end

    def press_key(key)
      0 != Libxkbcommon.xkb_state_update_key(to_native, key.code, XKB_KEY_DOWN)
    end

    def release_key(key)
      0 != Libxkbcommon.xkb_state_update_key(to_native, key.code, XKB_KEY_UP)
    end
  end
end
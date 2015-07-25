module Xkbcommon
  class Modifier
    def initialize(keymap, idx)
      @keymap = keymap
      @index = idx
      @name = Libxkbcommon.xkb_keymap_mod_get_name(keymap.to_native, idx)
    end

    attr_reader :keymap, :index, :name

    def active_for_state?(state)
      0 < Libxkbcommon.xkb_state_mod_index_is_active(state.to_native, index, Libxkbcommon::XKB_STATE_MODS_EFFECTIVE)
    end
  end
end
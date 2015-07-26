module Xkbcommon
  class Modifier
    SYMBOLS = [
      Libxkbcommon::XKB_KEY_Shift_L,
      Libxkbcommon::XKB_KEY_Shift_R,
      Libxkbcommon::XKB_KEY_Control_L,
      Libxkbcommon::XKB_KEY_Control_R,
      Libxkbcommon::XKB_KEY_Caps_Lock,
      Libxkbcommon::XKB_KEY_Shift_Lock,
      Libxkbcommon::XKB_KEY_Meta_L,
      Libxkbcommon::XKB_KEY_Meta_R,
      Libxkbcommon::XKB_KEY_Alt_L,
      Libxkbcommon::XKB_KEY_Alt_R,
      Libxkbcommon::XKB_KEY_Super_L,
      Libxkbcommon::XKB_KEY_Super_R,
      Libxkbcommon::XKB_KEY_Hyper_L,
      Libxkbcommon::XKB_KEY_Hyper_R,
      Libxkbcommon::XKB_KEY_ISO_Lock,
      Libxkbcommon::XKB_KEY_ISO_Level2_Latch,
      Libxkbcommon::XKB_KEY_ISO_Level3_Shift,
      Libxkbcommon::XKB_KEY_ISO_Level3_Latch,
      Libxkbcommon::XKB_KEY_ISO_Level3_Lock,
      Libxkbcommon::XKB_KEY_ISO_Level5_Shift,
      Libxkbcommon::XKB_KEY_ISO_Level5_Latch,
      Libxkbcommon::XKB_KEY_ISO_Level5_Lock,
      Libxkbcommon::XKB_KEY_ISO_Group_Shift,
      Libxkbcommon::XKB_KEY_ISO_Group_Latch,
      Libxkbcommon::XKB_KEY_ISO_Group_Lock,
      Libxkbcommon::XKB_KEY_ISO_Next_Group,
      Libxkbcommon::XKB_KEY_ISO_Next_Group_Lock,
      Libxkbcommon::XKB_KEY_ISO_Prev_Group,
      Libxkbcommon::XKB_KEY_ISO_Prev_Group_Lock,
      Libxkbcommon::XKB_KEY_ISO_First_Group,
      Libxkbcommon::XKB_KEY_ISO_First_Group_Lock,
      Libxkbcommon::XKB_KEY_ISO_Last_Group,
      Libxkbcommon::XKB_KEY_ISO_Last_Group_Lock
    ]

    def initialize(keymap, index)
      @keymap, @index = keymap, index
      @name = Libxkbcommon.xkb_keymap_mod_get_name(keymap.to_native, index).to_sym
    end

    attr_reader :keymap, :index, :name, :keys

    def keys=(keys)
      return if @keys
      @keys = [*keys].freeze
    end
  end
end
module Xkbcommon
  class Modifier
    SYMBOLS = [
      :Shift_L,
      :Shift_R,
      :Control_L,
      :Control_R,
      #:Caps_Lock,
      #:Shift_Lock,
      :Meta_L,
      :Meta_R,
      :Alt_L,
      :Alt_R,
      :Super_L,
      :Super_R,
      :Hyper_L,
      :Hyper_R,
      #:ISO_Lock,
      :ISO_Level2_Latch,
      :ISO_Level3_Shift,
      :ISO_Level3_Latch,
      #:ISO_Level3_Lock,
      :ISO_Level5_Shift,
      :ISO_Level5_Latch,
      #:ISO_Level5_Lock,
      :ISO_Group_Shift,
      :ISO_Group_Latch,
      #:ISO_Group_Lock,
      :ISO_Next_Group,
      #:ISO_Next_Group_Lock,
      :ISO_Prev_Group,
      #:ISO_Prev_Group_Lock,
      :ISO_First_Group,
      #:ISO_First_Group_Lock,
      :ISO_Last_Group#,
      #:ISO_Last_Group_Lock
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
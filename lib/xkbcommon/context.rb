module Xkbcommon
  class Context
    class << self
      def finalize(native)
        Proc.new { Libxkbcommon.xkb_context_unref(native) }
      end
    end

    def initialize(flags = Libxkbcommon::XKB_CONTEXT_NO_FLAGS)
      @to_native = Libxkbcommon.xkb_context_new(flags)

      ObjectSpace.define_finalizer(self, self.class.finalize(to_native))
    end

    attr_reader :to_native

    def default_keymap
      keymap_from_names
    end

    def keymap_from_names(rules: nil, model: nil, layout: nil, variant: nil, options: nil,
        flags: Libxkbcommon::XKB_KEYMAP_COMPILE_NO_FLAGS)
      names = Libxkbcommon::XkbRuleNames.new
      names.rules = rules if rules
      names.model = model if model
      names.layout = layout if layout
      names.variant = variant if variant
      names.options = options if options

      Keymap.new(self, Libxkbcommon.xkb_keymap_new_from_names(to_native, names, flags))
    end

    def keymap_from_file(file,
                         format: Libxkbcommon::XKB_KEYMAP_FORMAT_TEXT_V1,
                         flags: Libxkbcommon::XKB_KEYMAP_COMPILE_NO_FLAGS)
      Keymap.new(self, Libxkbcommon.xkb_keymap_new_from_file(to_native, file, format, flags))
    end

    def keymap_from_string(string,
                           format: Libxkbcommon::XKB_KEYMAP_FORMAT_TEXT_V1,
                           flags: Libxkbcommon::XKB_KEYMAP_COMPILE_NO_FLAGS)
      Keymap.new(self, Libxkbcommon.xkb_keymap_new_from_string(to_native, string, format, flags))
    end

    def keymap_from_buffer(buffer,
                           length,
                           format: Libxkbcommon::XKB_KEYMAP_FORMAT_TEXT_V1,
                           flags: Libxkbcommon::XKB_KEYMAP_COMPILE_NO_FLAGS)
      Keymap.new(self, Libxkbcommon.xkb_keymap_new_from_buffer(to_native, buffer, length, format, flags))
    end
  end
end
module Xkbcommon
  class Keymap
    class ModifierParser
      def initialize(parser)
        @parser = parser
        modifier_count = Libxkbcommon.xkb_keymap_num_mods(parser.keymap.to_native)
        @modifiers = (0..modifier_count-1).map{ |idx| Modifier.new(parser.keymap, idx) }
        @modifier_keys = Modifier::SYMBOLS.map{ |symbol| parser.symbol_key_combinations[symbol] }.compact.map(&:first)
        parse
        @modifiers.select!(&:keys)
      end

      attr_reader :parser, :modifier_keys, :modifiers

      private

      def parse
        state = Xkbcommon::State.new(parser.keymap)

        modifier_keys.each do |key|
          new_state_components = state.press_key(key) || 0

          if state_changed?(new_state_components)
            symbol = state.symbol_for_key(key)
            parser.symbol_key_combinations[symbol] ||= key if symbol

            active_modifiers(state).each do |mod|
              mod.keys ||= key
            end
          end

          state.release_key(key)

          # to release a locked state
          state.press_key(key)
          state.release_key(key)
        end
      end

      def state_changed?(state_components)
        state_components & Libxkbcommon::XKB_STATE_MODS_EFFECTIVE != 0
      end

      def active_modifiers(state)
        modifiers.select{ |mod| state.modifier_active?(mod) }
      end
    end
  end
end
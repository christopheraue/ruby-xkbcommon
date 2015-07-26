module Xkbcommon
  class Keymap
    class Parser
      def initialize(keymap)
        @keymap = keymap
      end

      attr_reader :keymap

      def keys
        @keys ||= begin
          min_code = Libxkbcommon.xkb_keymap_min_keycode(@keymap.to_native)
          max_code = Libxkbcommon.xkb_keymap_max_keycode(@keymap.to_native)
          keycode_range = min_code..max_code

          codes = keycode_range.select do |code|
            # Todo: This does not seem to filter out keys that do not exist on the keyboard?
            0 < Libxkbcommon.xkb_keymap_num_layouts_for_key(@keymap.to_native, code)
          end
          codes.map{ |code| Key.new(self, code) }
        end
      end

      def modifiers
        symbols # will be parsed while parsing symbols
        @modifiers
      end

      def symbols
        @symbols ||= begin
          symbols = parse_symbols
          # first parse round will give us all modifier keys, so we can parse
          # what keys active which modifiers next

          @modifiers = parse_modifiers(symbols)

          all_combinations(@modifiers).each do |modifiers|
            symbols = parse_symbols(symbols, modifiers)
          end

          symbols
        end
      end

      def characters
        symbols # will be parsed while parsing symbols
        @characters
      end

      private

      def parse_symbols(symbols = {}, modifiers = [])
        state = Xkbcommon::State.new(@keymap)
        modifier_mask = modifiers.map{ |mod| 1 << mod.index }.reduce(0, :|)
        state.update_mask(depressed_mods: modifier_mask)

        keys.each do |key|
          symbol = state.symbol_for_key(key)
          if symbol
            symbol.keys = [modifiers.map(&:keys), key].flatten
            # We just need one key combo to create the symbol. The first should be the simplest,
            # we take that one.
            symbols[symbol.name] ||= symbol
            if symbol.character
              @characters ||= {}
              # We just need one key combo to create the character. The first should be the simplest,
              # we take that one.
              @characters[symbol.character] ||= symbol
            end
          end
        end

        symbols
      end

      def parse_modifiers(symbols)
        modifier_count = Libxkbcommon.xkb_keymap_num_mods(@keymap.to_native)
        not_activated_modifiers = (0..modifier_count-1).map{ |idx| Modifier.new(@keymap, idx) }
        activated_modifiers = []

        state = Xkbcommon::State.new(@keymap)

        modifier_keys = Modifier::SYMBOLS.select{ |sym| symbols[sym] }.map{ |sym| symbols[sym].keys }
        modifier_keys.each do |keys|
          new_state_components = state.press_keys(keys) || 0

          if new_state_components & Libxkbcommon::XKB_STATE_MODS_EFFECTIVE != 0
            # Once we found a modifier and know how to activate it we no longer need to check it
            newly_activated_modifiers = not_activated_modifiers.select{ |mod| state.modifier_active?(mod) }
            newly_activated_modifiers.each{ |mod| mod.keys = keys }

            not_activated_modifiers -= newly_activated_modifiers
            activated_modifiers += newly_activated_modifiers
          end

          state.release_keys(keys)
        end

        activated_modifiers
      end

      def all_combinations(array)
        1.upto(array.size).inject([]) do |memo, group_size|
          memo + array.combination(group_size).to_a
        end
      end
    end
  end
end
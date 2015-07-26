module Xkbcommon
  class Keymap
    class Parser
      def initialize(keymap)
        @keymap = keymap
        parse
      end

      attr_reader :keymap, :symbol_key_combinations, :character_key_combinations,
        :unmapped_key_combinations, :modifiers

      private

      def parse
        @symbol_key_combinations = {}
        @character_key_combinations = {}
        @unmapped_key_combinations = []

        parse_keys # without any modifiers

        # find all modifiers that may be activated and how to do so
        @modifiers = ModifierParser.new(self).modifiers

        all_combinations(modifiers).each do |modifiers|
          parse_keys(modifiers)
        end
      end

      def parse_keys(modifiers = [])
        state = Xkbcommon::State.new(keymap)
        state.update_mask(depressed_mods: modifier_mask(modifiers))

        keymap.keys.each do |key|
          key_combination = [modifiers.map(&:keys), key].flatten
          symbol = state.symbol_for_key(key)
          if symbol
            @symbol_key_combinations[symbol] ||= key_combination
            character = state.utf8_of_key(key)
            @character_key_combinations[character] ||= key_combination if character
          else
            @unmapped_key_combinations << key_combination
          end
        end
      end

      def modifier_mask(modifiers)
        modifiers.map{ |mod| 1 << mod.index }.reduce(0, :|)
      end

      def all_combinations(array)
        1.upto(array.size).inject([]) do |memo, level|
          memo + array.combination(level).to_a
        end
      end
    end
  end
end
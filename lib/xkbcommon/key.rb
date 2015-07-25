module Xkbcommon
  class Key
    class << self
      def code_to_name(code)
        codes_to_names[code]
      end

      private

      def codes_to_names
        @names ||= begin
          keys = Uinput.constants.select{ |c| c.to_s.start_with?('KEY_') }
          keys.map do |c|
            code = Uinput.const_get(c)
            name = c.to_s[4..-1]
            name = Integer(name) rescue name.to_sym
            [code, name]
          end.to_h
        end
      end
    end

    def initialize(keymap, code)
      @keymap = keymap
      @code = code
      @name = self.class.code_to_name(code)
    end

    attr_reader :keymap, :code, :name

    def to_utf8_for_state(state)
      utf8_size = 8
      utf8 = FFI::MemoryPointer.new(:char, utf8_size)
      Libxkbcommon.xkb_state_key_get_utf8(state.to_native, code, utf8, utf8_size)
      utf8.read_string
    end
  end
end
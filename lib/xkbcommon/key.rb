require 'uinput'

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
      @scan_code = code - 8 # about offset 8: http://xkbcommon.org/doc/current/xkbcommon_8h.html#ac29aee92124c08d1953910ab28ee1997
      @name = self.class.code_to_name(@scan_code)
    end

    attr_reader :keymap, :code, :scan_code, :name

    def inspect
      "#<#{self.class.name}:0x#{'%014x' % __id__} @code=#{code} @name=#{name.inspect}>"
    end
  end
end
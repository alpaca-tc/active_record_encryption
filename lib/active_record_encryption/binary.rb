# frozen_string_literal: true

require 'stringio'

module ActiveRecordEncryption
  class Binary < ::StringIO
    FORMATS = {
      u_long_long: {
        length: 8,
        code: 'Q>'
      },
      long_long: {
        length: 8,
        code: 'q>'
      },
      u_int: {
        length: 4,
        code: 'L>'
      },
      int: {
        length: 4,
        code: 'l>'
      },
      u_short: {
        length: 2,
        code: 'S>'
      },
      short: {
        length: 2,
        code: 's>'
      },
      u_char: {
        length: 1,
        code: 'C'
      },
      char: {
        length: 1,
        code: 'c'
      }
    }.freeze

    FORMATS.each do |format_name, format|
      class_eval(<<-METHOD, __FILE__, __LINE__ + 1)
        def read_#{format_name}
          read(#{format[:length]}).unpack('#{format[:code]}')[0]
        end

        def write_#{format_name}(value)
          write([value].pack('#{format[:code]}'))
        end
      METHOD
    end

    def initialize(*)
      super
      binmode
    end

    def write_string_255(value)
      write_u_char(value.bytesize)
      write(value)
    end

    def read_string_255
      read(read_u_char)
    end
  end
end

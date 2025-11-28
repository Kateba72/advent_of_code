module AoC
  module Y2019
    class Intcode

      ADD = 1
      MULTIPLY = 2
      TERMINATE = 99

      attr_reader :program, :instruction_pointer, :testing

      def initialize(program, testing: false)
        @program = program.dup
        @instruction_pointer = 0
        @testing = testing
      end

      def run
        loop do
          case program[instruction_pointer]
          when ADD
            set_address_param(3) { address_param(1) + address_param(2) }
            @instruction_pointer += 4
          when MULTIPLY
            set_address_param(3) { address_param(1) * address_param(2) }
            @instruction_pointer += 4
          when TERMINATE
            return
          end

          p program if testing

        end
      end

      private

      def address_param(number)
        program[param number]
      end

      def param(number)
        program[instruction_pointer + number]
      end

      def set_address_param(number)
        program[param number] = yield
      end

    end
  end
end

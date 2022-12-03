require 'rspec'

module CustomMatchers
  class BeMappedBy
    def initialize(receiver_or_proc, message=nil )
      if Proc === receiver_or_proc || Method === receiver_or_proc
        @block = receiver_or_proc
      else
        @block = nil
        @receiver = receiver_or_proc
        @message = message
      end
      @failures = []
    end

    def to(values)
      @output_values = values
      self
    end

    def matches?(values)
      @input_values = values

      @input_values.zip(@output_values).all? do |input, output|
        if (actual_output = evaluate(input)) == output
          true
        else
          @failures << [input, actual_output]
          false
        end
      end
    end

    def failure_message
      text = "expected #{method_representation} to map\n"
      text << @input_values.zip(@output_values).map { |input, output| "* #{input} => #{output},\n" }.join
      text << "but mapped\n"
      text << @failures.map { |input, output| "* #{input} => #{output},\n" }.join
      text << "\n"
    end

    private

    def method_representation
      @method_representation ||=
        if @message
          "`#{@receiver}.#{@message}`"
        elsif (value_block_snippet = extract_value_block_snippet)
          "`#{value_block_snippet}`"
        else
          'result'
        end
    end

    def evaluate(at)
      @block ? @block.call(at) : @receiver.send(@message, at)
    end

    if RSpec::Support::RubyFeatures.ripper_supported?
      def extract_value_block_snippet
        return nil unless @value_proc
        RSpec::Expectations::BlockSnippetExtractor.try_extracting_single_line_body_of(@value_proc, @matcher_name)
      end
    else
      def extract_value_block_snippet
        nil
      end
    end
  end

  def be_mapped_by(...)
    BeMappedBy.new(...)
  end
end

RSpec::configure do |config|
  config.include(CustomMatchers)
end

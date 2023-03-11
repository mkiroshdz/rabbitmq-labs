require 'yaml'
require 'json'
require 'optparse'
require 'google/protobuf'

class Command
  Data = Struct.new(:body, :routing, :exchange, :file, :parser, :schema, keyword_init: true)
  Formats = {
    'json' => JSON,
    'yaml' => YAML
  }

  def initialize(raw_args)
    @args = Data.new(body: [], exchange: [], routing: nil, file: nil, parser: nil)
    arg_parser.parse!(raw_args)
  end

  def args
    {
      routing_key: @args.routing,
      exchange_type: @args.exchange[0],
      exchange_name: @args.exchange[1],
      body: body,
      schema: @args.schema
    }
  end

  private

  def arg_parser
    @parser ||= OptionParser.new do |opts|
      opts.banner = "Usage: producer.rb [options]"

      opts.on("-r ROUTING_KEY", "--routing=ROUTING_KEY", "Set routing key") do |routing| 
        @args.routing = routing
      end

      opts.on("-b BODY", "--body=BODY", "Set message body") do |body|
        @args.body.push(body)
      end

      opts.on("-k CLASS", "--klass=CLASS", "Set schema class") do |klass| 
        @args.schema = ::Google::Protobuf::DescriptorPool.generated_pool.lookup(klass)&.msgclass 

        if !@args.schema
          puts "Schema class '#{klass}' is not defined"
          exit(1)
        end
      end

      opts.on("-s FILENAME", "--source=FILENAME", "Set source filename") do |filename| 
        begin
          @args.file = File.new(filename)
        rescue Errno::ENOENT => e
          puts e.message
          exit(1)
        end
      end

      opts.on("-f FORMAT", "--format=FORMAT", "Set message format [json | yaml]") do |format| 
        @args.parser = Formats[format.downcase]

        if !Formats.has_key?(format.downcase)
          puts "Invalid format. expectec [json | yaml]"
          exit(1)
        end
      end

      opts.on("-e EXCHANGE", "--exchange=EXCHANGE", "Set exchange [type:name]. ex: direct:exchange.name") do |ex| 
        @args.exchange = ex.split(':').select {|i| i.to_s.length > 0 }

        if @args.exchange.size < 2
          puts "Invalid exchange. Expected format [type:name]"
          exit(1)
        end
      end
    end
  end

  def body
    inline_body + file_body
  end

  def inline_body
    return @args.body unless parser

    @args.body.map {|m| parser.parse(m) }
  end

  def file_body
    plain = @args.file.read
    return [plain] unless parser
    
    formatted = parser.parse(plain)
    return formatted if formatted.is_a?(Array)

    [formatted]
  end

  def parser
    @args.parser
  end
end
require 'optparse'
require './connection'

Options = Struct.new(:msgs, :key, :type, :exchange)
args = Options.new([], 'test', 'direct', 'amq.direct')

parser = OptionParser.new do |opts|
  opts.banner = "Usage: producer.rb [options]"

  opts.on("-k KEY", "--key=KEY", "Set routing key") do |key|
    args.key = key
  end

  opts.on("-m MSG", "--msg=MSG", "Set msg body") do |msg|
    args.msgs << msg
  end

  opts.on("-t TYPE", "--type=TYPE", "Set exchange type") do |t|
    args.type = t
  end

  opts.on("-e EXCHANGE", "--exchange=EXCHANGE", "Set exchange name") do |ex|
    args.exchange = ex
  end
end

parser.parse!(ARGV)

puts args

Connection.exec do |channel|
  exchange = channel.send(args.type, args.exchange)
  args.msgs.each do |m|
    exchange.publish(m, routing_key: args.key)
    puts "[x] sent #{args.type} exchange - key: #{args.key} body: #{args.msgs}"
  end
end


require './connection/connection'
require './command/producer'

begin
  args = Command.new(ARGV).args
  Connection.exec do |channel|
    exchange = channel.send(args[:exchange_type], args[:exchange_name])
    args[:body].each do |msg|
      payload = Marshal.dump(msg)
      exchange.publish(payload, routing_key: args[:routing_key])
      puts "[x] sent #{msg}"
    end
  end
rescue => e
  puts e.message
  puts "Execution finished"
end


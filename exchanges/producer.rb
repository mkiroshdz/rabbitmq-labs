require './connection/connection'
require './command/producer'
require './exchanges/payload'

begin
  args = Command.new(ARGV).args  
  payload = Payload.new(args[:schema])
  Connection.exec do |channel|
    exchange = channel.send(args[:exchange_type], args[:exchange_name])
    args[:body].each do |msg|
      exchange.publish(payload.encode(msg), routing_key: args[:routing_key])
      puts "[x] sent #{msg}"
    end
  end
rescue => e
  puts e.message
  puts "Execution finished"
end


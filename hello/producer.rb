require './connection/connection'
require './command/producer'

Connection.exec do |channel|
  channel.default_exchange.publish('Hello world!', routing_key: 'test')
  puts '[x] sent hello world'
end


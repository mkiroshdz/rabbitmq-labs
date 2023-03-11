require './connection/connection'
require './exchanges/payload'

Connection.exec do |channel|
  puts '[x] Waiting for msgs'
  queue_name, klass = ARGV
  schema = ::Google::Protobuf::DescriptorPool.generated_pool.lookup(klass)&.msgclass if klass
  payload = Payload.new(schema)
  queue = channel.queue(queue_name, durable: true )
  queue.subscribe(block: true) do |delivery, props, raw_body|
    body = payload.decode(raw_body)
    puts "[x] received #{delivery} #{props} #{body}"
    puts '*' * 20
  end
  puts '[x] sent hello world'
end


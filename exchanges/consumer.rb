require './connection/connection'

Connection.exec do |channel|
  puts '[x] Waiting for msgs'
  queue = channel.queue(ARGV[0], durable: true )
  queue.subscribe(block: true) do |delivery, props, body|
    puts "[x] received #{delivery} #{props} #{body}"
    puts '*' * 20
  end
  puts '[x] sent hello world'
end


require './connection'

Connection.exec do |channel|
  puts '[x] Waiting for msgs'
  queue = channel.queue('test')
  queue.subscribe(block: true) do |delivery, props, body|
    puts "[x] received #{body}"
  end
  puts '[x] sent hello world'
end


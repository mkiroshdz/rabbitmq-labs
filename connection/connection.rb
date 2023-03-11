require 'bunny'
require 'yaml'

class Connection
  def self.connection
    @connection ||= Bunny.new(
      host: credentials['host'],
      user: credentials['user'],
      vhost: credentials['vhost'],
      pass: credentials['pass']
    )
  end

  def self.credentials
    file = File.new('credentials.yml')
    YAML.load(file.read)
  ensure
    file.close
    {}
  end

  def self.exec
    connection.start
    channel = connection.create_channel
    yield channel
  ensure
    connection.close
  end
end
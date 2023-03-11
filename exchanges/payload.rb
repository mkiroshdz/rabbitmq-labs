class Payload
  def initialize(schema)
    @schema = schema
  end

  def encode(msg)
    if @schema
      model = @schema.new(msg)
      @schema.encode(model)
    else
      Marshal.dump(msg)
    end
  end

  def decode(msg)
    if @schema
      @schema.decode(msg)
    else
      Marshal.load(msg)
    end
  end
end
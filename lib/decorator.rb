class Decorator
  def initialize(object)
    @object = object
  end

  def eql?(other)
    self == other
  end

  def ==(other)
    other.class == self.class && other.object == object
  end

  def hash
    [self.class, object].hash
  end

  def to_param
    object.to_param
  end

  def method_missing(message, *args, &block)
    if object.respond_to?(message)
      object.send(message, *args, &block)
    else
      super
    end
  end

  def respond_to_missing?(message, include_all = false)
    object.respond_to?(message, include_all)
  end

  protected

  attr_reader :object
end

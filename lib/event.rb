class Momentous::EventBase
  attr_reader :is_propagated

  def initialize
    @is_propagated = true
  end

  alias_method :is_propagated?, :is_propagated

  def stop_propagation
    @is_propagated = false
  end
end

class Momentous::Event < Momentous::EventBase
  def initialize(attributes={})
    @attributes = attributes.is_a?(Hash) ? attributes : {}
    super()
  end

  def method_missing(name, *args, &block)
    attributes.fetch(name) { nil }
  end

  private
  attr_reader :attributes
end

class Momentous::Event
  attr_reader :is_propagated

  def initialize(attributes={})
    @is_propagated = true
  end

  alias_method :is_propagated?, :is_propagated

  def stop_propagation
    @is_propagated = false
  end
end

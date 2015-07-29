class Momentous::EventDispatcher
  def initialize
    @listeners = {}
  end

  def add_listener(event_name, listener)
    (listeners[:event_name] ||= []) << listener
  end

  def get_listeners(event_name)
    listeners[:event_name]
  end

  def has_listeners(event_name)
    listeners[:event_name] != nil and listeners[:event_name].count > 0
  end

  def remove_listener(event_name, listener)
    event_listeners = listeners[:event_name]
    return if event_listeners.nil?

    candidate = event_listeners.bsearch { |x| x == listener }
    event_listeners.delete(candidate)
  end

  private
  attr_reader :listeners
end


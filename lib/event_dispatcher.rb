class Momentous::EventDispatcher
  def initialize
    @listeners = {}
  end

  def dispatch(event_name, event_obj=nil)
    return unless has_listeners(event_name)

    do_dispatch(get_listeners(event_name), event_name, event_obj)
  end

  def add_listener(event_name, listener)
    (listeners[:event_name] ||= []) << listener
  end

  def get_listeners(event_name = nil)
    return [] if event_name.nil?

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

  def do_dispatch(listeners, event_name, event_obj)
    listeners.each do |listener|
      listener[0].public_send(listener[1], event_obj)
    end
  end
end


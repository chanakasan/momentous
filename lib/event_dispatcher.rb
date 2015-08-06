class Momentous::EventDispatcher
  def initialize
    @listeners = {}
  end

  def dispatch(event_name, event_data=nil)
    return unless has_listeners(event_name)

    if event_data.nil? or event_data.is_a? Hash
      event_data = ::Momentous::Event.new(event_data)
    end

    do_dispatch(get_listeners(event_name), event_name, event_data)
  end

  def add_listener(event_name, listener)
    (listeners[event_name] ||= []) << listener
  end

  def get_listeners(event_name = nil)
    return [] if event_name.nil?

    listeners[event_name]
  end

  def has_listeners(event_name)
    listeners[event_name] != nil and listeners[event_name].count > 0
  end

  def remove_listener(event_name, listener)
    current_listeners = listeners[event_name]
    return if current_listeners.nil?

    candidate = current_listeners.assoc(listener)
    current_listeners.delete(candidate)
  end

  private
  attr_reader :listeners

  def do_dispatch(listeners, event_name, event_obj)
    listeners.each do |listener|
      break unless event_obj.is_propagated?

      listener[0].public_send(listener[1], event_obj)
    end
  end
end


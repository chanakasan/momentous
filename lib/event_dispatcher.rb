class Momentous::EventDispatcher
  def initialize
    @listeners = {}
  end

  def add_listener(event_name, listener)
    (@listeners[:event_name] ||= []) << listener
  end

  def get_listeners(event_name)
    @listeners[:event_name]
  end
end


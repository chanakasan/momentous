require_relative '../lib/momentous'

# test doubles
class UserEmailSender
  def send_welcome_email(event);
  end
end

RSpec.describe Momentous::Event do
  it 'is popagated by default' do
    expect(subject.is_propagated?).to eql(subject.is_propagated)
    expect(subject.is_propagated?).to eql(true)
  end

  it 'stops propagation of the event' do
    subject.stop_propagation
    expect(subject.is_propagated?).to eql(false)
  end
end

RSpec.describe Momentous::EventDispatcher do
  let(:user_email_sender) { instance_double(UserEmailSender) }
  let(:generic_event) { Momentous::Event.new }

  it 'initially has an empty listeners array' do
    expect(subject.get_listeners()).to eql([])
    expect(subject.has_listeners(:non_existing_event)).to eql(false)
  end

  it 'stores listeners for an event' do
    subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])

    expect(subject.get_listeners(:after_signup)).to eql([[user_email_sender, :send_welcome_email]])
  end

  it 'knows whether listeners exist for an event' do
    expect(subject.has_listeners(:after_signup)).to eql(false)

    subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])
    expect(subject.has_listeners(:after_signup)).to eql(true)
  end

  it 'removes existing listeners for an event' do
    subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])
    expect(subject.has_listeners(:after_signup)).to eql(true)

    subject.remove_listener(:after_signup, [user_email_sender, :send_welcome_email])

    expect(subject.has_listeners(:after_signup)).to eql(false)
  end

  it 'dispatches events without a event object' do
    subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])

    expect(user_email_sender).to receive(:send_welcome_email)
    subject.dispatch(:after_signup)
  end

  it 'dispatches events with a event object' do
    subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])

    expect(user_email_sender).to receive(:send_welcome_email).with(generic_event)
    subject.dispatch(:after_signup, generic_event)
  end
end

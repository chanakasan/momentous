require_relative '../lib/momentous'

# TODO
#
# * use better error messages for inside method_missing

# test doubles
class UserEmailSender
  @@received_attribs = false

  def send_welcome_email(event);
    event.stop_propagation
    set_received_attribs(event)
  end

  def set_received_attribs(event)
    @@received_attribs = true if event.some_key == 'some_val'
  end

  def self.received_attribs?
    @@received_attribs
  end
end

class PromotionEmailSender
  def send_email(event); end
end

RSpec.describe Momentous::EventBase do
  it 'is popagated by default' do
    expect(subject.is_propagated?).to eql(subject.is_propagated)
    expect(subject.is_propagated?).to eql(true)
  end

  it 'stops propagation of the event' do
    subject.stop_propagation
    expect(subject.is_propagated?).to eql(false)
  end
end

RSpec.describe Momentous::Event do
  it 'inherits from EventBase class' do
    expect(subject).to be_kind_of(Momentous::EventBase)
  end

  it 'accepts the event name when initializing' do
    expect(subject.name).to be_nil

    event = Momentous::Event.new(:custom_event)
    expect(event.name).to eql(:custom_event)
  end

  it 'accepts an attributes hash when initializing' do
    event = Momentous::Event.new(:custom_event, { some_key: 'some_val' })
    expect(event.some_key).to eql('some_val')
  end
end

RSpec.describe Momentous::EventDispatcher do
  let(:user_email_sender) { instance_double(UserEmailSender) }
  let(:promotion_email_sender) { instance_double(PromotionEmailSender) }
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

  context 'when dispatching events' do
    it 'dispatches an event without an event object' do
      subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])

      expect(user_email_sender).to receive(:send_welcome_email)
      subject.dispatch(:after_signup)
    end

    it 'stops propagation of an event when needed' do
      subject.add_listener(:after_signup, [UserEmailSender.new, :send_welcome_email])
      subject.add_listener(:after_signup, [promotion_email_sender, :send_email])

      expect(promotion_email_sender).to_not receive(:send_email)
      subject.dispatch(:after_signup)
    end

    it 'dispatches an event with an event object' do
      subject.add_listener(:after_signup, [user_email_sender, :send_welcome_email])

      expect(user_email_sender).to receive(:send_welcome_email).with(generic_event)
      subject.dispatch(:after_signup, generic_event)
    end

    it 'dispatches an event with an attributes hash' do
      subject.add_listener(:after_signup, [UserEmailSender.new, :send_welcome_email])

      expect(UserEmailSender.received_attribs?).to eql(false)
      subject.dispatch(:after_signup, { some_key: 'some_val' })
      expect(UserEmailSender.received_attribs?).to eql(true)
    end
  end
end

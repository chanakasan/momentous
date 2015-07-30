require_relative '../lib/momentous'

# test doubles
class UserMailer
  def send_welcome_email(user); end
end

RSpec.describe Momentous::EventDispatcher do
  let(:user_mailer) { instance_double(UserMailer) }
  let(:user) { Struct.new(:name).new }

  it 'initially has an empty listeners array' do
    expect(subject.get_listeners()).to eql([])
    expect(subject.has_listeners(:non_existing_event)).to eql(false)
  end

  it 'stores listeners for an event' do
    subject.add_listener(:after_signup, [user_mailer, :send_welcome_email])

    expect(subject.get_listeners(:after_signup)).to eql([[user_mailer, :send_welcome_email]])
  end

  it 'knows whether listeners exist for an event' do
    expect(subject.has_listeners(:after_signup)).to eql(false)

    subject.add_listener(:after_signup, [user_mailer, :send_welcome_email])
    expect(subject.has_listeners(:after_signup)).to eql(true)
  end

  it 'removes existing listeners for an event' do
    subject.add_listener(:after_signup, [user_mailer, :send_welcome_email])
    expect(subject.has_listeners(:after_signup)).to eql(true)

    subject.remove_listener(:after_signup, [user_mailer, :send_welcome_email])

    expect(subject.has_listeners(:after_signup)).to eql(false)
  end

  it 'dispatches events' do
    subject.add_listener(:after_signup, [user_mailer, :send_welcome_email])

    expect(user_mailer).to receive(:send_welcome_email).with(user)
    subject.dispatch(:after_signup, user)
  end
end

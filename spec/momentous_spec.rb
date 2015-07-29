require_relative '../lib/momentous'

class UserMailer; end
class SignupListener
  attr_accessor :user

  def initialize(user_mailer = UserMailer.new)
    @user_mailer = user_mailer
  end

  def after_signup(user)
    @user_mailer.send_welcome_email(user)
  end
end

RSpec.describe Momentous::EventDispatcher do
  let(:signup_listener) { SignupListener.new }

  it 'stores listeners for an event' do
    subject.add_listener(:after_signup, [signup_listener, :after_signup])

    expect(subject.get_listeners(:after_signup)).to eql([[signup_listener, :after_signup]])
  end

  it 'knows whether listeners exist for an event' do
    expect(subject.has_listeners(:after_signup)).to eql(false)

    subject.add_listener(:after_signup, [signup_listener, :after_signup])
    expect(subject.has_listeners(:after_signup)).to eql(true)
  end

  it 'removes existing listeners for an event' do
    subject.add_listener(:after_signup, [signup_listener, :after_signup])
    expect(subject.has_listeners(:after_signup)).to eql(true)

    subject.remove_listener(:after_signup, [signup_listener, :after_signup])

    expect(subject.has_listeners(:after_signup)).to eql(false)
  end
end

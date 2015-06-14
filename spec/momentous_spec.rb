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
  it 'stores listeners for an event' do
    signup_listener = SignupListener.new
    subject.add_listener(:after_signup, [signup_listener, :after_signup])

    expect(subject.get_listeners(:after_signup)).to eql([[signup_listener, :after_signup]])
  end
end

require 'test_helper'

class UserMessageTest < ActionMailer::TestCase
  test "user_message" do
    @expected.subject = 'UserMessage#user_message'
    @expected.body    = read_fixture('user_message')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMessage.create_user_message(@expected.date).encoded
  end

end

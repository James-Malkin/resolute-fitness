class TestMailer < ApplicationMailer
  def test_email
    mail(to: 'j.steven.malkin@gmail.com', subject: 'Test Email')
end

class ApplicationMailer < ActionMailer::Base
  default from: %{"TestGuru Project" <rubyzza.dev@gmail.com>}
  layout 'mailer'
end

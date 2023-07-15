# frozen_string_literal: true

require 'rest-client'
require 'dotenv'

Dotenv.load

## EmailService
module EmailService
  def self.send_confirmation_email(user, token)
    domain = ENV['APPLICATION_DOMAIN']

    RestClient.post "https://api:#{ENV['MAIL_GUN_KEY']}"\
      "@api.mailgun.net/v3/#{ENV['MAIL_GUN_DOMAIN_NAME']}/messages",
                    from: "Mailgun Sandbox <postmaster@#{ENV['MAIL_GUN_DOMAIN_NAME']}>",
                    to: "#{user.user_name} <#{user.email}>",
                    subject: "Hello #{user.user_name}",
                    template: 'confirm your email',
                    'h:X-Mailgun-Variables': JSON.generate({ domain:,
                                                             code: token })
  end
end

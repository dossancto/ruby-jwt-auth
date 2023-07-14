# frozen_string_literal: true

require 'rest-client'
require 'dotenv'

Dotenv.load

## EmailService
module EmailService
  def self.send_simple_message(user, _text)
    puts ENV['MAIL_GUN_KEY']
    puts ENV['MAIL_GUN_DOMAIN_NAME']
    puts user.email

    RestClient.post "https://api:#{ENV['MAIL_GUN_KEY']}"\
      "@api.mailgun.net/v3/#{ENV['MAIL_GUN_DOMAIN_NAME']}/messages",
                    from: "Mailgun Sandbox <postmaster@#{ENV['MAIL_GUN_DOMAIN_NAME']}>",
                    to: "#{user.user_name} <#{user.email}>",
                    subject: "Hello #{user.user_name}",
                    :template => 'confirm your email',
                    ':h:X-Mailgun-Variables' => "{'test': 'test'}"

    # RestClient.post "https://api:#{ENV['MAIL_GUN_KEY']}"\
    #   "@api.mailgun.net/v3/#{ENV['MAIL_GUN_DOMAIN_NAME']}/messages",
    #                 from: "Mailgun Sandbox <postmaster@#{ENV['MAIL_GUN_DOMAIN_NAME']}>",
    #                 to: "#{user.user_name} <#{user.email}>",
    #                 subject: "Hello #{user.user_name}",
    #                 text:
  end

  def self.send_confirmation_email(user, token)
    domain = ENV['APPLICATION_DOMAIN']
    puts domain

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

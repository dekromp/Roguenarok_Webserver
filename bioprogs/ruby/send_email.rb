#!/usr/bin/ruby
RAILS_ROOT = File.expand_path(File.join(File.dirname(__FILE__), '../..'))
require 'net/smtp'
require "#{File.dirname(__FILE__)}/../../config/environment.rb"

class SendEmail

  def initialize(opts)

    @email_address = nil;
    @link = nil;
    i = 0;
    while i < opts.size
      if opts[i].eql?("-e")
        @email_address = opts[i+1]
        i = i+1
      elsif opts[i].eql?("-l")
        @link = opts[i+1]
        i = i+1
      else
         raise "ERROR in Input!, unknown option #{opts[i]}!"
      end
      i = i+1
    end

    send_email
    
  end

  def send_email
    Net::SMTP.start(ENV['MAILSERVICE_ADDRESS'], 25) do |smtp|
      smtp.open_message_stream("#{ENV['SERVER_NAME']}", @email_address) do |f|
        
        f.puts "From: #{ENV['SERVER_NAME']}"
        
        f.puts "To: #{@email_address}"

        f.puts 'Subject: Your RAxML job has been finished.'

        f.puts "Check your results here: #{@link}"
        
      end
      
    end
  end
end

SendEmail.new(ARGV)

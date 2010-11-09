require 'redis'
require 'json'
module Cinch
  module Plugins
    module Memo
      class Redis

        def initialize(host, port)
          @backend = ::Redis.new(:host => host, :port => port, :thread_safe => true)
        end
        
        def store(recipient, sender, message)
          @backend.sadd recipient, [sender, message, Time.now.to_s].to_json
        end
        
        def retrieve(recipient)
          messages = @backend.smembers recipient
          @backend.del(recipient)
          messages
        end

      end # Redis
    end # Memo
  end # Plugins
end # Cinch

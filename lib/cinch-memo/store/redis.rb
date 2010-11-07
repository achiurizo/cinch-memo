require 'redis'

module Cinch
  module Plugins
    module Memo
      class Redis

        def initialize(host, port)
          @backend = ::Redis.new(:host => host, :port => port)
        end
        
        def store(recipient, sender, message)
          @backend.sadd recipient, [sender, message, Time.now].to_json
        end
        
        def retrieve(recipient)
          messages = @backend.get recipient
          @backend.srem(recipient)
          messages
        end

      end # Redis
    end # Memo
  end # Plugins
end # Cinch

require 'redis'
require 'redis-namespace'
require 'json'
module Cinch
  module Plugins
    module Memo
      class Redis

        def initialize(host, port)
          redis = ::Redis.new(:host => host, :port => port, :thread_safe => true)
          @backend =  ::Redis::Namespace.new "cinch-memo", :redis => redis
        end

        def store(recipient, sender, message)
          @backend.sadd recipient, [sender, message, Time.now.to_s].to_json
        end

        def retrieve(recipient)
          messages = @backend.smembers recipient
          @backend.del(recipient)
          messages ? messages.collect {|m| JSON.parse(m) } : nil
        end

      end # Redis
    end # Memo
  end # Plugins
end # Cinch

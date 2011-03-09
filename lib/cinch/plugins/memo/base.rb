module Cinch
  module Plugins
    module Memo
      class Base
        include Cinch::Plugin
        attr_accessor :backend

        def initialize(*args)
          super
          @bot.debug "[memo] Connecting to #{config[:store]} store"
          @backend =
          case config[:store]
          when :redis then Cinch::Plugins::Memo::Redis.new(config[:host], config[:port])
          when :mongo then Cinch::Plugins::Memo::Mongo.new(config[:host], config[:port], :db => config[:db], :collection => config[:collection])
          else
            config[:store]
          end
        end

        match %r{memo (.+?) (.+)}, :method => :store_message
        match "memo?",             :method => :get_message

        listen_to :join

        def listen(m)
          get_messages(m, true, false)
        end

        # Stores message to designated user.
        def store_message(m, nick, message)
          if nick == @bot.nick
            m.reply "You can't store a message for me."
          else
            @backend.store(nick,m.user.nick, message)
            @bot.info "[memo] Stored memo from #{m.user.nick} for #{nick}"
            m.reply "Message saved!"
          end
        end

        # Gets messages for the designated user
        def get_message(m, private = false, report = true)
          messages = @backend.retrieve(m.user.nick)
          unless messages.nil? || messages.empty?
            @bot.info "[memo] Received memos for #{m.user.nick}"

            messages.each do |msg|
              if private
                m.user.send(msg)
              else
                m.reply msg
              end
            end
          else
            m.reply "There are no messages for you." if report
          end
        end

      end # Base

    end # Memo
  end # Plugins
end #Cinch

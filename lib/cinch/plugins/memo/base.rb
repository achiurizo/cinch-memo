module Cinch
  module Plugins
    module Memo
      class Base
        include Cinch::Plugin
        attr_accessor :backend

        class << self
          attr_accessor :store, :host, :port, :db, :collection

          def configure(&block)
            yield self
          end
        end

        def initialize(*args)
          super
          @bot.debug "[memo] Connecting to #{self.class.store} store"
          @backend =
          case self.class.store
          when :redis then Cinch::Plugins::Memo::Redis.new(self.class.host, self.class.port)
          when :mongo then Cinch::Plugins::Memo::Mongo.new(self.class.host, self.class.port, :db => self.class.db, :collection => self.class.collection)
          else
            self.class.store
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

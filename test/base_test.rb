require File.expand_path('../teststrap',__FILE__)

context "Base" do
  dont_register!
  setup { @bot = mock() }

  helper :base do |store|
    Cinch::Plugins::Memo::Base.configure do |c|
      c.store = store
    end
    Cinch::Plugins::Memo::Base
  end


  context "#configure" do
    setup { base(:redis) }
    asserts(:store).equals :redis
  end

  context "#initialize" do
    setup { base(:redis).new(@bot) }
    asserts_topic.assigns :backend
  end

  context "#store_message" do
    setup do
      @bot.expects(:nick).returns('bob')
      @base = base(:redis).new(@bot)
      @message = mock()
    end

    context "with bot nick" do
      setup { @message.expects(:reply).with("You can't store a message for me.").returns(true) }
      asserts("that it doesn't save message for bot") { @base.store_message(@message,'bob','hey') }
    end

    context "with non-bot nick" do
      setup do
        @replier = mock() ; @replier.expects(:nick).returns("chris")
        @message.expects(:user).returns(@replier)
        @message.expects(:reply).with("Message saved!").returns(true)
        @backend = mock()
        @backend.expects(:store).with('john','chris','hey')
        @base.backend = @backend
      end
      asserts("that it does save message") { @base.store_message(@message, 'john', 'hey') }
    end
  end

  context "#deliver_message" do
    setup do
      @replier = mock() ; @replier.expects(:nick).returns('chris')
      @message = mock() ; @message.expects(:user).returns(@replier)
      @backend = mock()
      @base = base(:redis).new(@bot)
    end

    context "with message" do
      setup do
        @backend.expects(:retrieve).with('chris').returns(["john: hey there!", "john: bye!"])
        @base.backend = @backend
        @message.expects(:reply).with("john: hey there!")
        @message.expects(:reply).with("john: bye!")
      end
      asserts("that it returns message") { @base.get_message(@message) }
    end

    context "without message" do
      setup do
        @backend.expects(:retrieve).with('chris').returns([])
        @base.backend = @backend
        @message.expects(:reply).with("There are no messages for you.").returns(true)
      end
      asserts("that it says there aren't messages") { @base.get_message(@message) }
    end
  end

  context "#listen" do
    setup do
      @replier = mock() ; @replier.stubs(:nick).returns('chris')
      @message = mock() ; @message.stubs(:user).returns(@replier)
      @backend = mock()
      @base = base(:redis).new(@bot)
    end
    context "with messages" do
      setup do
        @u = mock() ; @u.expects(:send).with('john')
        @base.expects(:User).with('chris').returns(@u)
        @backend.expects(:retrieve).with('chris').returns(['john'])
        @base.backend = @backend
      end
      asserts("that it pings message") { @base.listen(@message) }
    end

    context "without messages" do
      setup do
        @backend.expects(:retrieve).with('chris').returns([])
        @base.expects(:User).with('chris').never
        @base.backend = @backend
      end
      asserts("that it doesn't ping them") { @base.listen(@message) }
    end
  end

end

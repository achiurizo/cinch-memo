require File.expand_path('../../teststrap',__FILE__)
require 'redis'
context "Redis" do
  dont_register!
  setup { @bot = mock() }
  
  helper :base do
    Cinch::Plugins::Memo::Base.configure do |c|
      c.store = :redis
      c.host  = 'localhost'
      c.port  = '6709'
    end
    Cinch::Plugins::Memo::Base
  end

  context "#initialize" do
    setup { ::Redis.expects(:new).with(:host => 'localhost', :port => '6709', :thread_safe => true) }
    setup { base.new(@bot) }
    asserts_topic.assigns :backend
  end

  context "#store" do
    setup do
      Timecop.freeze(Time.now)
      backend = mock() ; backend.expects(:sadd).with('bob', ['chris','yo yo', Time.now].to_json).returns(true)
      ::Redis.expects(:new).with(:host => 'localhost', :port => '6709', :thread_safe=>true).returns(backend)
      Cinch::Plugins::Memo::Redis.new('localhost','6709')
    end
    asserts("that it stores message") { topic.store('bob', 'chris','yo yo') }
  end

  context "#retrieve" do
    setup do
      Timecop.freeze(Time.now)
      backend = mock() ; backend.expects(:smembers).with("bob").returns("\[\"a\",\"b\",\"c\"\]")
      backend.expects(:del).with('bob').returns(true)
      ::Redis.expects(:new).with(:host => 'localhost', :port => '6709', :thread_safe=>true).returns(backend)
      Cinch::Plugins::Memo::Redis.new('localhost','6709')
    end
    asserts("that it retrieves message") { topic.retrieve('bob') }
  end
end

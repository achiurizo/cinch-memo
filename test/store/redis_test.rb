require File.expand_path('../../teststrap',__FILE__)

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
    setup { @redis_class = mock('redis_class')}
    setup { @redis_class.expects(:new).with(:host => 'localhost', :port => '6709') }
    setup { base.new(@bot) }
    asserts_topic.assigns :backend
  end
  
  context "#store" do     
  end
  
  context "#retrieve" do 
  end
end
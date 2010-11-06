require 'rubygems'
require 'riot'
require 'mocha'
require File.expand_path('../../lib/cinch-memo',__FILE__)

class Riot::Situation
  include Mocha::API
end

class Riot::Context
  # Turn off bot register hook
  def dont_register!
    setup { Cinch::Plugins::Memo::Base.stubs(:__register_with_bot).with(any_parameters).returns(true) }
  end
end

class Object
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end
    result
  end
end

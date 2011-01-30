require 'cinch'

module Cinch
  module Plugins
    module Memo
      autoload :Base,   File.expand_path('../memo/base',__FILE__)
      autoload :Redis,  File.expand_path('../memo/store/redis',__FILE__)
      # autoload :Mongo,  File.expand_path('../memo/store/mongo',__FILE__)
    end
  end
end

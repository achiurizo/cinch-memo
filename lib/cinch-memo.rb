require 'cinch'

module Cinch
  module Plugins
    module Memo
      autoload :Base,   'cinch-memo/base'
      autoload :Redis,  'cinch-memo/store/redis'
    end
  end
end

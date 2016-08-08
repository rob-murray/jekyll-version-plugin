# Hack ...or stub Liquid classes and methods used in plugin
module Liquid
  class Tag
  end

  class Template
    def self.register_tag(*_); end
  end
end

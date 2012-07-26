require 'kindlizer/generator/hatena-generator'

module Kindlizer
  module Generator
    class RubyTrunkChanges < HatenaGenerator
      def target_url
        'http://d.hatena.ne.jp/nagachika/'
      end
    end
  end
end

if __FILE__ == $0
  Kindlizer::Generator::RubyTrunkChanges::new(Dir.pwd).generate(Time.local(2012,7,24)) do |html|
  end
end

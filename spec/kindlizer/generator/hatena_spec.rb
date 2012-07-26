# -*- coding: utf-8 -*-

require File.expand_path('../../../../lib/kindlizer/generator/ruby-trunk-changes', __FILE__ )

describe 'hatena generator' do
	context 'normal' do
		it 'makes html file' do
			Dir.mktmpdir do |dir|
				Kindlizer::Generator::RubyTrunkChanges::new( dir ).generate( Time::now ) do |html|
					html.should eq "#{dir}/src/hatena.html"
				end
			end
		end
	end
end

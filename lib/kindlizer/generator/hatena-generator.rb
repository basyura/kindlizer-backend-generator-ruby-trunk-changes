#-*- coding: utf-8 -*-
require 'nokogiri'
require 'open-uri'
require 'tmpdir'
require 'pathname'

module Kindlizer
  module Generator
    class HatenaGenerator

      def target_url
        throw StandardError.new("no support")
      end

      def initialize(tmpdir)
				@src_dir = tmpdir + '/src'
				Dir::mkdir( @src_dir )
      end

      def generate(now)

        top     = Nokogiri(open(target_url, 'r:euc-jp', &:read))
        day     = top.xpath('//div[@class="day"]')[0]
        section = top.xpath('.//div[@class="section"]')[0]
        section.xpath("//p[@class='sectionfooter']").remove
        section.xpath("//p[@class='share-button sectionfooter']").remove

        unless section.xpath('./h3/a')[0]['href'] =~ /\/([0-9]*?)\//
          puts "not supported"
          return
        end

        #if $1 !=  now.strftime("%Y%m%d")
        #  puts "no entry"
        #  return
        #end

        fetch_images(section)

        strip_links(section)

        html = generate_html(top, day, section)

        File.open("#{@src_dir}/hatena.html", 'w') {|f| f.puts html}

        yield "#{@src_dir}/hatena.html"
      end

      private
      #
      #
      def fetch_images(section)
        section.xpath('.//img').each do |img|
          src = img['src']
          src = 'http://d.hatena.ne.jp' + src if src =~ /^\//
          image = open(src, &:read )
          open("#{@src_dir}/#{File.basename(src)}", 'wb'){|fp| fp.write image}
          img['src'] = File.basename(src)
        end
      end
      #
      #
      def strip_links(node)
        node.xpath('.//a').each do |a|
          a.replace(Nokogiri::XML::Text.new(a.text, node))
        end
      end
      #
      #
      def generate_html(top, day, section)
        title = top.xpath('//title').text.encode('utf-8') + 
                  '-' + day.xpath('.//span[@class="date"]')[0].text

        html =<<-EOF
        <html>
        <head>
          <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
          <title>#{title}</title>
        </head>
        <body>
          <h1>#{title}</h1>
          #{section.to_s.encode('utf-8')}
        </body>
        </html>
        EOF
        html
      end
    end
  end
end


require 'mechanize'

class Scrape

  def initialize
    @mechanize = Mechanize.new
    @visited   = []
  end

  def run(urls)
    scraped_urls = []

    urls.each do |url|
      if !@visited.include?(url) && !url.scan('en.wikipedia.org').empty?
        begin
          rawpage = @mechanize.get(url)

          rawpage.links_with(:href=>/^?wiki/).uniq.each do |a|
            if a.href.scan(/http/).empty?
              scraped_urls << "https://en.wikipedia.org#{a.href}"
            else
              scraped_urls << a.href
            end
          end

          lines = []

          rawpage.search('p').each do |p|
            lines << p.text
          end

          File.open("articles", 'a') do |file|
            file.puts lines
          end
        rescue
        end
      end
    end

    @visited += urls
    run(scraped_urls)
  end

end

@scrape = Scrape.new
@scrape.run([
  'https://en.wikipedia.org/wiki/Main_Page'
])

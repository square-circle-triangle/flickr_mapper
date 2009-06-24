require 'rubygems'
require 'hpricot'
require 'open-uri'

module FlickrMapper
end

%w(base connection parser photoset photo).each{|r| require(File.join(File.dirname(__FILE__), File.basename(__FILE__, '.rb'), r))}
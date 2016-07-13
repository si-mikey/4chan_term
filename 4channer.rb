#!/usr/bin/env ruby -W0

require 'pry'
require 'oga'
require 'open-uri'

base_url = "http://boards.4chan.org/gif/"

(1..10).each do |page_num|
  page_num = "" if page_num == 1
  document = Oga.parse_html(open(base_url + page_num))
  document.css(".thread").each_with_index do |thread, index|
    next if index == 0
    puts "###### Thread #{index} ######"
    title = thread.css(".file + .postInfo .subject").text
    puts "Title: " + title
    message = thread.at_css("blockquote").text
    puts "Summary: " + message
    link = base_url + thread.at_css(".summary .replylink").get('href') rescue NoMethodError
    puts "Link: " + link unless link.is_a? NoMethodError
    puts "###### Thread #{index} ######"
    puts "######-----------------######"
    puts ""
    puts "open thread?: [y]es/[n]o/[q]uit"
    y_n = gets
    if y_n.strip == 'y'
      system("chromium-browser #{link}")
    elsif y_n.strip == 'q'
      abort
    end
  end
end

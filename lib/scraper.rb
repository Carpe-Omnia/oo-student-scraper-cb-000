require 'open-uri'
require 'pry'
require 'nokogiri'
class Scraper

  def self.scrape_index_page(index_url)
    doc = Nokogiri::HTML(open(index_url))
    butt = doc.css(".student-card")
    #scrape = doc.parse('.student-card')
    #scrape
    ray = butt.collect do |thing|
      name1 = thing.css(".student-name").text
      location1 = thing.css(".student-location").text
      profile_url1 = thing.css("a")[0]["href"]
    #profile_url = profile_url["href"]
      stuff = {:name => "#{name1}", :location => "#{location1}", :profile_url => "#{profile_url1}"}
    end
    ray
  end
  def self.edit(input, removal)
    save = input
    puts "save #{save}"
    check = input.delete(removal)
    if check == nil
      check = save
    end
    puts "check #{check}"
    check
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    vitals = doc.css(".vitals-container")
    name = vitals.css(".profile-name").text
    location = vitals.css(".profile-location").text
    profile_quote = vitals.css(".profile-quote").text.chomp
    social = vitals.css("a")
    facebook = nil
    github = nil
    linkedin = nil
    twitter = nil
    blog = nil
    social.each do |icon|

      chopped = icon["href"]
      puts chopped
      chopped = self.edit(chopped, "https")
      chopped = self.edit(chopped, "http")
      chopped = self.edit(chopped, "www.")
      chopped = self.edit(chopped, "::/")
      if chopped[0] == "f"
        facebook = icon["href"]
      elsif chopped[0] == "g"
        github = icon["href"]
      elsif chopped[0] == "l"
        linkedin = icon["href"]
      elsif chopped[0] == "i"
        twitter = icon["href"]
      elsif chopped[-1] == "m"
        blog = icon["href"]
      end
    end
    details = doc.css(".details-container")
    bio = details.css(".description-holder")
    bio = bio.css("p").text
    value = {
      :name => name,
      :location => location,
      :profile_quote => profile_quote,
      :profile_url => profile_url,
      :bio => bio,
      :linkedin => linkedin,
      :github => github,
      :facebook => facebook,
      :twitter => twitter,
      :blog => blog
    }
    value

  end

end
testo = Scraper.scrape_profile_page("./fixtures/student-site/students/joe-burgess.html")
puts testo
puts testo.class

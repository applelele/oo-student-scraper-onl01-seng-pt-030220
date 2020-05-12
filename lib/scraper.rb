require 'open-uri'
require 'nokogiri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    # index_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/"
    doc = Nokogiri::HTML(open(index_url))
    scraped_students = doc.css(".student-card")
    @student_index_array = []

    scraped_students.each do |student|
      @student_hash = Hash.new
      @student_hash[:name] = student.css("h4.student-name").text
      @student_hash[:location] = student.css("p.student-location").text
      @student_hash[:profile_url] = student.css("a").attribute("href").value
      @student_index_array << @student_hash
    end
    @student_index_array
    # binding.pry
  end
  
  def self.scrape_profile_page(profile_url)
    @profile_hash = Hash.new
    # profile_url = "https://learn-co-curriculum.github.io/student-scraper-test-page/#{@student_hash[:profile_url]}"
    node = Nokogiri::HTML(open(profile_url))
    scraped_profile = node.css(".social-icon-container a")
    scraped_profile.each do |profile|
      if profile.attribute("href").value.include?("twitter")
        @profile_hash[:twitter] = profile.attribute("href").value
      elsif profile.attribute("href").value.include?("linkedin")
        @profile_hash[:linkedin] = profile.attribute("href").value
      elsif profile.attribute("href").value.include?("github")
        @profile_hash[:github] = profile.attribute("href").value
      else @profile_hash[:blog] = profile.attribute("href").value
      end
    end

    @profile_hash[:profile_quote] = node.css(".vitals-text-container .profile-quote").text
    @profile_hash[:bio] = node.css(".details-container .bio-block .description-holder p").text

    @profile_hash
  end

end

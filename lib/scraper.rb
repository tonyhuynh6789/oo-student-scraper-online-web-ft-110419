require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
      student_hash = []
      doc = Nokogiri::HTML(open(index_url))
      doc.css('.student-card').map do |student|
        # binding.pry
          hash =  {
            name: student.css('.student-name').text, 
            location: student.css('.student-location').text,
            profile_url: student.css('a').attribute("href").value
          }
         
          student_hash << hash
      end 
      student_hash 
  end 
  

  def self.scrape_profile_page(profile_url)
    student_hash = {}
    doc = Nokogiri::HTML(open(profile_url))
    container = doc.css('.social-icon-container a').collect do |icon|
      icon.attribute('href').value
    end 
  
    container.map do |link|
      if link.include?("twitter")
        student_hash[:twitter] = link
      elsif link.include?("linkedin")
        student_hash[:linkedin] = link
      elsif link.include?("github")
        student_hash[:github] = link
      elsif link.include?(".com")
          student_hash[:blog] = link
      end 
    end 
    student_hash[:profile_quote] = doc.css('.profile-quote').text.gsub("\"", "")
    student_hash[:bio] = doc.css('.bio-content').text
    # binding.pry
    student_hash
  end
end


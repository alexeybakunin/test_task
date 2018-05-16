require_relative '../helpers/base_page'

class ProfilePage < BasePage
	JOB_TITLE              = { css: "span.up-active-context.up-active-context-title.fe-job-title" }
	DESCRIPTION            = { css: "p[itemprop='description']" 																	}
	HOURLY_RATE   	       = { css: "span.up-active-context span[itemprop='pricerange']" 					}
	EARNED                 = { css: "h3.m-xs-bottom > span[itemprop='pricerange']"								}
  PROFILE_NAME           = { css: "div.media-body h2.m-xs-bottom span[itemprop='name']"					}
  SKILLS                 = { css: "a.o-tag-skill"											                          }
	attr_reader :driver

	def initialize(driver)
		super
	end

	def job_title
		text_of(JOB_TITLE)
	end

	def name
		text_of(PROFILE_NAME)
	end

	def job_description
		text_of(DESCRIPTION)
	end

	def hourly_rate
		text_of(HOURLY_RATE)
	end

	def skills
		find_all(SKILLS).map {|skill| skill.text}.reject(&:empty?)
	end 

	def is_displayed?
		loop do
			begin
				find(JOB_TITLE).displayed?
				find(PROFILE_NAME).displayed?
				break
			  rescue Selenium::WebDriver::Error::StaleElementReferenceError
			 next
		  end
	  end
	end 

	def compare_with(freelancer)
		profile_items = { job_title: job_title, name: name, hourly_rate: hourly_rate, job_description: job_description, skills: skills}
		freelancers_items = freelancer.attributes
		profile_items.each do |key,value|
		condition = case key 
								when :job_description
									"does not" if not freelancers_items[key].chomp("...").split(" ") - value.gsub("\n", " ").split(" ") 
								when :skills
									"does not" if not (freelancers_items[key] - value).empty?
								else
									"does not" if not value == freelancers_items[key]
								end
		puts "Profile's #{key} #{condition} match with data from search results"
		end
	end

end

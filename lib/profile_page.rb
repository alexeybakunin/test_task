require_relative './base_page'

class ProfilePage < BasePage
	JOB_TITLE              = { css: "span.up-active-context.up-active-context-title.fe-job-title" }
	DESCRIPTION            = { css: "p[itemprop='description']" }
	HOURLY_RATE   	       = { css: "span.up-active-context span[itemprop='pricerange']" }
  PROFILE_NAME           = { css: "div.media-body h2.m-xs-bottom span[itemprop='name']"}
  SKILLS                 = { css: "div.o-profile-skills.m-sm-top.ng-scope'"}
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
		profile_items = { job_title: job_title, name: name, hourly_rate: hourly_rate }
		freelancers_items = { job_title: freelancer.job_title, 
														name: freelancer.name, hourly_rate: freelancer.hourly_rate 
													}
		profile_items.each do |key,value|
			condition = "does not" if not value == freelancers_items[key]
			puts "Profile's #{key} #{condition} match with data from search results"
		end
	end

end

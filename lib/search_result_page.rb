require_relative './base_page'
require_relative './freelancer'
require 'pry'

class SearchResultPage < BasePage

	FILTER               = { css: "div.filters-button"                       }
	CATEGORIES_LIST   	 = { partial_link_text: "See all categories"         }
	WEB_CATEGORY   	     = { partial_link_text: "Web, Mobile & Software Dev" }
	FILTER_STATUS		 = { css: "span.m-sm-top-bottom.text-muted"          }
	FREELANCERS			 = { css: "section[data-qa='freelancer']"            }
	FREELANCER_NAME      = { css: "a[data-qa='tile_name']"                   }
	FREELANCER_TITLE     = { css: "h4[data-qa='tile_title']"                 }
	FREELANCER_RATE      = { css: "strong.pull-left"                         }
	FREELANCER_DESC      = { css: "p[data-qa='tile_description']"            }
	FREELANCER_SKILLS    = { css: "a[data-log-label='tile_skill']"           }
	SEARCH_BUTTON        = { css: "button.btn.btn-primary.m-0-top-bottom"    }

	attr_reader :driver

	def initialize(driver)
		super 
	end

	def is_displayed?
		loop do
			begin
				find(FILTER).displayed?
				find(CATEGORIES_LIST).displayed?
				find(WEB_CATEGORY).displayed?
				find(FILTER_STATUS).displayed?
				break
			  rescue Selenium::WebDriver::Error::StaleElementReferenceError
			 next
		  end
	  end
	end 

	def search_result
		freelancers = find_all FREELANCERS
	end

	def get_freelancers
		freelancers = search_result
		freelancers.map { |freelancer| 
			Freelancer.new( freelancer.find_element(FREELANCER_NAME).text, 
							freelancer.find_element(FREELANCER_TITLE).text, 
							freelancer.find_element(FREELANCER_DESC).text, 
							freelancer.find_element(FREELANCER_RATE).text, 
							freelancer.find_element(FREELANCER_SKILLS).text)   
							}
	end
	
	def open_freelancer(number)
		freelancers = search_result
		freelancers[number-1].click
	end
end

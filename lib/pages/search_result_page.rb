require_relative '../helpers/base_page'
require_relative './freelancer'

class SearchResultPage < BasePage

	FILTER                    = { css: "div.filters-button"                           }
	CATEGORIES_LIST   	      = { partial_link_text: "See all categories"             }
	WEB_CATEGORY   	          = { partial_link_text: "Web, Mobile & Software Dev"     }
	FILTER_STATUS		      		= { css: "span.m-sm-top-bottom.text-muted"              }
	FREELANCERS			     			= { css: "section[data-qa='freelancer']"                }
	FREELANCER_NAME           = { css: "a[data-qa='tile_name']"                       }
	FREELANCER_TITLE          = { css: "h4[data-qa='tile_title']"                     }
	FREELANCER_RATE           = { css: "strong.pull-left"                             }
	FREELANCER_DESC           = { css: "p[data-qa='tile_description']"                }
	FREELANCER_EARNED         = { css: "div[data-freelancer-earnings] span strong"    }
	FREELANCER_SUCCESS_RATE   = { css: "div.progress-bar > span"                      }
	FREELANCER_COUNTRY        = { css: "div[data-freelancer-location]"                }
	FREELANCER_SKILLS         = { css: "a[data-log-label='tile_skill']"               }
	SEARCH_BUTTON             = { css: "button.btn.btn-primary.m-0-top-bottom"        }

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
			Freelancer.new( freelancer_attributes(freelancer) )   
							}
	end
	
	def open_freelancer(number)
		freelancers = search_result
		freelancers[number-1].click
	end

	private

	def freelancer_attributes(freelancer)
		{ 
			name: get_attribute(FREELANCER_NAME, freelancer),
			job_title: get_attribute(FREELANCER_TITLE, freelancer), 
			job_description: get_attribute(FREELANCER_DESC, freelancer), 
			hourly_rate: get_attribute(FREELANCER_RATE, freelancer),
			total_earned: get_attribute(FREELANCER_EARNED, freelancer),
			success_rate:	get_attribute(FREELANCER_SUCCESS_RATE, freelancer),
			country: get_country(freelancer), 
			skills:	get_skills(FREELANCER_SKILLS, freelancer)
		}
	end

	def get_attribute(locator, freelancer)
		begin
			find(locator, freelancer).text
			rescue Selenium::WebDriver::Error::NoSuchElementError
			"not present on search screen"
		end
	end

	def get_skills(locator, freelancer)
		find_all(locator, freelancer).map {|skill| skill.text}
	end

	def get_country(freelancer)
		find(FREELANCER_COUNTRY, freelancer).attribute("data-location").match(/(?<=country\":\")(.*?)(?=\",)/)[0]
	end
end

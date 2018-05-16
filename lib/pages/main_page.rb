require_relative '../helpers/base_page'

class MainPage < BasePage

	SEARCH_TYPE_DROPDOWN   = { css: "div[data-qa='s_button']"       }
	SEARCH_FREELANCERS     = { css: "a[data-qa='freelancer_value']" }
	SEARCH_JOB   	         = { css: "a[data-qa='freelancer_value']" }
  SEARCH_BOX			       = { css: "input[data-qa='s_input']"      }

	attr_reader :driver

	def initialize(driver)
		super
	end

	def search_freelancers(keyword)
		click_on  SEARCH_TYPE_DROPDOWN
		click_on  SEARCH_FREELANCERS
		type SEARCH_BOX, keyword
		submit SEARCH_BOX
	end

	def search_job(keyword)
		click_on SEARCH_TYPE_DROPDOWN
		click_on SEARCH_JOB
		type SEARCH_BOX, keyword
		submit SEARCH_BOX
		end
end

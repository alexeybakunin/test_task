require_relative '../helpers/base_page'
require_relative './freelancer'
# Page that opened after user search for keyword
class SearchResultPage < BasePage

  FILTER                    = { css: "div.filters-button"                           }
  CATEGORIES_LIST           = { partial_link_text: "See all categories"             }
  WEB_CATEGORY              = { partial_link_text: "Web, Mobile & Software Dev"     }
  FILTER_STATUS             = { css: "span.m-sm-top-bottom.text-muted"              }
  FREELANCERS               = { css: "section[data-qa='freelancer']"                }
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
    super [find(FILTER), find(CATEGORIES_LIST), find(WEB_CATEGORY), find(FILTER_STATUS)]
  end 
  # method that get all freelancers as webdriver objects from search result first page
  def search_result
    freelancers = find_all FREELANCERS
  end
  # method that transform all collected freelancers webdriver objects into Freelancer object
  def get_freelancers
    freelancers = search_result
    freelancers.map { |freelancer|
      Freelancer.new(freelancer_attributes(freelancer))   
              }
  end
  # open selected freelancer's profile page
  def open_freelancer(number)
    freelancers = search_result
    freelancers[number-1].click
  end

  private
  # create attributes for Freelancer object
  def freelancer_attributes(freelancer)
    { 
      name: get_attribute(FREELANCER_NAME, freelancer),
      job_title: get_attribute(FREELANCER_TITLE, freelancer), 
      job_description: get_attribute(FREELANCER_DESC, freelancer), 
      hourly_rate: get_attribute(FREELANCER_RATE, freelancer),
      total_earned: get_attribute(FREELANCER_EARNED, freelancer),
      success_rate: get_attribute(FREELANCER_SUCCESS_RATE, freelancer),
      country: get_attribute(FREELANCER_COUNTRY, freelancer), 
      skills: get_skills(FREELANCER_SKILLS, freelancer)
    }
  end
  # collect freelancers's attributes from search result page 
  def get_attribute(locator, freelancer)
    begin
      find(locator, freelancer).text
      rescue Selenium::WebDriver::Error::NoSuchElementError
      "not present on search screen"
    end
  end
  # collect freelancers's skills into array and transform to text
  def get_skills(locator, freelancer)
    find_all(locator, freelancer).map {|skill| skill.text}
  end
end

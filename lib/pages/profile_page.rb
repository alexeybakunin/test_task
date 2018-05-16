require_relative '../helpers/base_page'
# Screen that opened when you click on freelancer in search result page
# Collect all freelancer data from screen
class ProfilePage < BasePage
  JOB_TITLE              = { css: "span.up-active-context.up-active-context-title.fe-job-title" }
  DESCRIPTION            = { css: "p[itemprop='description']"                                   }
  HOURLY_RATE            = { css: "span.up-active-context span[itemprop='pricerange']"          }
  EARNED                 = { css: "h3.m-xs-bottom > span[itemprop='pricerange']"                }
  PROFILE_NAME           = { css: "div.media-body h2.m-xs-bottom span[itemprop='name']"         }
  SKILLS                 = { css: "a.o-tag-skill"                                               }
  COUNTRY                = { css: "strong[itemprop='country-name']"                             }
  SUCCESS_RATE           = { css: "cfe-job-success h3"                                          }
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

  def country
    text_of(COUNTRY)
  end

  def hourly_rate
    text_of(HOURLY_RATE)
  end

  def skills
    find_all(SKILLS).map {|skill| skill.text}.reject(&:empty?)
  end 

  def success_rate
    find_all(SUCCESS_RATE)[-1].text
  end

  def is_displayed?
    super [find(JOB_TITLE), find(PROFILE_NAME), find(SKILLS)]
  end 
  # method that compare data on freelancer's profile page with same data from search result page and print result to stdout
  def compare_with(freelancer)
    profile_items = { job_title: job_title, name: name, hourly_rate: hourly_rate,
                      job_description: job_description, skills: skills, country: country, success_rate: success_rate }
    profile_items.each do |key,value|
      condition = case key 
                  when :job_description
                    "does not" unless compare_description?(freelancer.attributes[key], value)
                  when :skills
                    "does not" unless (freelancer.attributes[key] - value).empty?
                  when :success_rate
                    "does not" unless freelancer.attributes[key].include?value
                  else
                    "does not" unless value == freelancer.attributes[key]
                  end
      puts "Profile's #{key} #{condition} match with data from search results"
    end
  end

  private

  # Descriptions on profile page has different formatting from search result page, could contains newlines
  # instead of spaces etc. and could end in the middle of word
  # method purpose is serialization of job description from profile page and and search result page to same format
  # (Array of strings) to avoid any collisions while compairing it. 
  def compare_description?(freelancer_descr, profile_descr)
    serialized_freelance_descr = freelancer_descr.chomp("...").split(" ")
    serialized_profile_descr = profile_descr.gsub("\n", " ").split(" ")[0..serialized_freelance_descr.size-1]
    comparision = serialized_freelance_descr - serialized_profile_descr
    if comparision.empty?
      return true
    # case if last word in short description is cutted
    elsif comparision.size == 1 and serialized_profile_descr[-1].include? serialized_freelance_descr[-1]
      return true
    end
    false
  end
end

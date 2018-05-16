require_relative './lib/helpers/base_page'
require_relative './lib/pages/main_page'
require_relative './lib/pages/profile_page'
require_relative './lib/pages/search_result_page'


ENV['base_url'] = 'http://www.upwork.com'
begin
  browser = ARGV[0].to_sym.downcase
  keyword = ARGV[1]

	driver = Selenium::WebDriver.for browser
	driver.manage.timeouts.implicit_wait = 5
	wait = Selenium::WebDriver::Wait.new(:timeout => 10)

	main_page = MainPage.new(driver)
	search_result_page = SearchResultPage.new(driver)
	profile_page = ProfilePage.new(driver)

	main_page.visit
	puts "Open main page"

	main_page.search_freelancers(keyword)
	puts "Search for freelancers"

	search_result_page.is_displayed?
	freelancers = search_result_page.get_freelancers
	puts "Check if freelancers data contains keyword"
	freelancers.each {|freelancer| freelancer.check_for_keyword(keyword) }

	search_result_page.open_freelancer(rand(1..10))
	puts "Open random freelancer from search"

	profile_page.is_displayed?

	freelancer = freelancers.select { |freelancer| freelancer.name == profile_page.name}[0]
	puts "Compairing data from opened #{freelancer.name} profile with previous stored data"
	profile_page.compare_with(freelancer)
ensure
	driver.quit
end

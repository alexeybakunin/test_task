require_relative '../spec_helper'

class BasePage

  attr_reader :driver

  def initialize(driver)
    @driver = driver
 	end

  def visit(url='/')
    driver.get(ENV['base_url'] + url)
 	end

  def find(locator)
    driver.find_element locator
  end

  def find_all(locator)
    driver.find_elements locator
   end

  def clear(locator)
    find(locator).clear
  end

  def type(locator, input)
    find(locator).send_keys input
  end

  def submit(locator)
    find(locator).submit
  end

  def click_on(locator)
    find(locator).click
  end

  def text_of(locator)
    find(locator).text
  end

  def title
    driver.title
  end
end

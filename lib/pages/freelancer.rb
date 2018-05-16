require_relative '../../spec_helper'

class Freelancer

	ATTRIBUTES = [:name, :job_title, :job_description, :hourly_rate, :total_earned, :success_rate, :country, :skills]

	attr_reader *ATTRIBUTES, :attributes
	
	def initialize(attributes)
		@attributes = attributes
			ATTRIBUTES.each do |var|
      instance_variable_set "@#{var}", @attributes[var]
    end
	end

	def check_for_keyword(keyword)
		items_to_check = {job_description: job_description, skills: skills, job_title: job_title}
		items_to_check.each do |key,value|
		condition = case key
								when :skills
									"does not" if not value.grep keyword.capitalize 
								else
									"does not" if not value.downcase.include? keyword.downcase
								end
			puts "Freelancer\'s #{name} #{key} #{condition} contains #{keyword}"
		end
	end
end

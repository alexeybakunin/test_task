require_relative '../spec_helper'

class Freelancer
	attr_reader :name, :job_title, :job_description, :hourly_rate, :skills

	def initialize(name, title, description="", rate="", skills=[])
		@name = name
		@job_title = title
		@job_description = description
		@hourly_rate = rate
		@skills = skills
	end

	def check_for_keyword(keyword)
		items_to_check = {job_description: job_description, skills: skills, job_title: job_title}
		items_to_check.each do |key,value|
			condition = "does not" if not value.downcase.include? keyword.downcase
			puts "Freelancer\'s #{name} #{key} #{condition} contains #{keyword}"
		end
	end
end

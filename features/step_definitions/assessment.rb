class Assessment
	attr_accessor :assessment
	attr_accessor :applicant
	attr_accessor :dependants
	attr_accessor :other_incomes
	attr_accessor :irregular_incomes
	attr_accessor :outgoings
	attr_accessor :capital
	attr_reader :uri_sequence

	def initialize unknown_param
      uri_sequence = {
      	assessment: "/assessments",
      	applicant: "/assessments/{id}/applicant",
      	dependents: "/assessments/{id}/dependants",
      	other_incomes: "/assessments/{id}/other_incomes",
      	irregular_incomes: "/assessments/{id}/irregular_incomes",
      	outgoings: "/assessments/{id}/outgoings"
      }
    end

    def get_url(name, assessment_id)
    	return @uri_sequence[name].gsub('{id}', assessment_id)
    end
end


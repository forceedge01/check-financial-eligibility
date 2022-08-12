class Assessment
	attr_accessor :version
	attr_accessor :id
	attr_accessor :assessment
	attr_accessor :applicant
	attr_accessor :dependants
	attr_accessor :other_incomes
	attr_accessor :irregular_incomes
	attr_accessor :outgoings
	attr_accessor :capital
	attr_reader :uri_sequence

	def initialize
      @uri_sequence = {
      	create_assessment: {:method => "post", :uri => "/assessments"},
      	add_applicant: {:method => "post", :uri => "/assessments/{id}/applicant"},
      	add_dependents: {:method => "post", :uri => "/assessments/{id}/dependants"},
      	add_other_incomes: {:method => "post", :uri => "/assessments/{id}/other_incomes"},
      	add_irregular_incomes: {:method => "post", :uri => "/assessments/{id}/irregular_incomes"},
      	add_outgoings: {:method => "post", :uri => "/assessments/{id}/outgoings"},
      	retrieve_assessment: {:method => "get", :uri => "/assessments"}
      }

      @id = ''
    end

    def get_request name, payload
        # if @uri_sequence.defined?(:"#{name}")
        #     raise "Invalid name provided for uri generation #{name}"
        # end

        request = @uri_sequence[:"#{name}"]

        if not payload.empty?
        	request = request.merge({:payload => payload})
        end

        request.merge({:headers => {}})
    end
end

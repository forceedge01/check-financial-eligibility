require 'active_model'

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
	attr_writer :headers

	def initialize
      @uri_sequence = {
      	create_assessment: {:method => "post", :uri => "/assessments"},
      	add_applicant: {:method => "post", :uri => "/assessments/{id}/applicant"},
      	add_dependants: {:method => "post", :uri => "/assessments/{id}/dependants"},
      	add_other_incomes: {:method => "post", :uri => "/assessments/{id}/other_incomes"},
      	add_irregular_incomes: {:method => "post", :uri => "/assessments/{id}/irregular_incomes"},
      	add_outgoings: {:method => "post", :uri => "/assessments/{id}/outgoings"},
      	add_capitals: {:method => "post", :uri => "/assessments/{id}/capitals"},
      	retrieve_assessment: {:method => "get", :uri => "/assessments"}
      }

      @id = ''
      @headers = {}
    end

    def addHeader name, value
    	@headers[name] = value
    end

    def get_request_uri name, payload = {}, params = {}
        # if @uri_sequence.defined?(:"#{name}")
        #     raise "Invalid name provided for uri generation #{name}"
        # end

        request = @uri_sequence[:"#{name}"]

        if request.nil?
        	raise "Expected to find a request for #{name}, but nothing found."
        end

        params.each_pair do | index, param | request[:uri] = request[:uri].gsub("{#{index}}", param) end

        if not payload.empty?
        	request = request.merge({:payload => payload})
        end

        request.merge({:headers => @headers})
    end

    def cleanse payload
    	payload = payload.to_json.gsub(/"(true)"/i, 'true').gsub(/"(false)"/i, 'false')

		JSON.parse(payload)
    end
end

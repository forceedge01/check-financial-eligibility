class RequestBag
	attr_accessor :api_version
	attr_accessor :requests
	attr_accessor :assessment_id
	attr_accessor :headers

	def initialize
		@requests = []
		@headers = {}
		@assessment_id = ''
	end

	def add request
		@requests.append request
	end

	def header name, value
		@headers[name] = value
	end

	def process
		puts @requests

		header 'Accept', 'application/json;version=5'

		@requests.each do | request |
			puts request
			case request[:method]
			when 'post'
				response = post request[:uri].gsub('{id}', @assessment_id), request[:payload], @headers.merge(request[:headers])
			when 'get'
				response = get request[:uri].gsub('{id}', @assessment_id), @headers.merge(request[:headers])
			else
				raise 'Incorrect request method provided '+request[:method]
			end

			puts response
		
			result = JSON.parse(response)

			if result['success'] == false
				raise response['message']
			end

			puts result

			if result.key?('assessment_id')
				@assessment_id = result['assessment_id']
			end

		end
	end
end

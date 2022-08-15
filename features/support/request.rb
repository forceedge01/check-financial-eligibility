class Request
	# attr_accessor :requests
	attr_accessor :headers

	def initialize
		@requests = []
		@headers = {}
	end

	def add request
		@requests.append request
	end

	def header name, value
		@headers[name] = value
	end

	def reset
		@requests = []
		@headers = {}
	end

	def process
		puts @requests

		@requests.each do | request |
			puts 'request to process is:'
			puts request
			case request[:method]
			when 'post'
				response = post request[:uri], request[:payload], @headers.merge(request[:headers])
			when 'get'
				response = get request[:uri], @headers.merge(request[:headers])
			else
				raise 'Incorrect request method provided '+request[:method]
			end

			# puts response
		
			result = JSON.parse(response)

			if result['success'] == false
				raise result['message']
			end

			puts result

			return result

			# puts result

			# if result.key?('assessment_id')
			# 	@assessment_id = result['assessment_id']
			# end

		end
	end
end

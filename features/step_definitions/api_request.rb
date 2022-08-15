require_relative 'assessment'
require_relative '../support/request'

assessment = Assessment.new
assessment.addHeader('Accept', 'application/json;version=5')
requestBag = Request.new

assessment_id = ''

Given('I am using version {int} of the API') do |int|
  page.driver.header "Accept", "application/json;version=#{int}"
end

Given('I create an assessment with the following details:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:client_reference_id=>"NP-Full-1", :submission_date=>Mon, 10 May 2021, :proceeding_types=>{:ccms_codes=>["DA001", "SE013", "SE003"]}}'

  assessment.assessment = assessment.cleanse table.rows_hash

  if assessment.assessment.key?('proceeding_types')
    assessment.assessment['proceeding_types'] = {'ccms_codes': assessment.assessment['proceeding_types'].split(';')}
  end

  payload = assessment.assessment.to_json
  request = assessment.get_request_uri('create_assessment', payload)
  requestBag.add(request)
  response = requestBag.process

  assessment_id = response['assessment_id']
  requestBag.reset
end

Given('I add the following applicant details for the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:applicant=>{:date_of_birth=>Thu, 20 Dec 1979, :involvement_type=>"applicant", :has_partner_opponent=>false, :receives_qualifying_benefit=>false}}'

  data = {"applicant": table.rows_hash}
  assessment.applicant = assessment.cleanse data

  payload = assessment.applicant.to_json
  request = assessment.get_request_uri('add_applicant', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

Given('I add the following dependent details for the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:dependants=>[{:date_of_birth=>Thu, 20 Dec 2018, :in_full_time_education=>false, :relationship=>"child_relative", :monthly_income=>0.0, :assets_value=>0.0}]}'

  data = { "dependants": table.hashes }
  assessment.dependants = assessment.cleanse data

  payload = assessment.dependants.to_json
  request = assessment.get_request_uri('add_dependants', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

Given('I add the following other_income details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:other_incomes=>[{:source=>"friends_or_family", :payments=>[{:date=>"2021-05-10", :amount=>100.0, :client_id=>"id1"}, {:date=>"2021-04-10", :amount=>100.0, :client_id=>"id2"}, {:date=>"2021-03-10", :amount=>100.0, :client_id=>"id3"}]}]}'

  data = { "other_incomes": {"source": string, "payments": table.hashes}}
  assessment.other_incomes = assessment.cleanse data

  payload = assessment.other_incomes.to_json
  request = assessment.get_request_uri('add_other_incomes', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

Given('I add the following irregular_income details in the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:payments=>[{:income_type=>"student_loan", :frequency=>"annual", :amount=>120.0}]}'

  data = {"payments": table.hashes}
  assessment.irregular_incomes = assessment.cleanse data

  payload = assessment.irregular_incomes.to_json
  request = assessment.get_request_uri('add_irregular_incomes', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

Given('I add the following outgoing details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:outgoings=>[{:name=>"rent_or_mortgage", :payments=>[{:payment_date=>"2021-05-10", :amount=>10.0, :client_id=>"id7"}, {:payment_date=>"2021-04-10", :amount=>10.0, :client_id=>"id8"}, {:payment_date=>"2021-03-10", :amount=>10.0, :client_id=>"id9"}]}]}'

  data = {"outgoings": ["name": string, "payments": table.hashes]}
  assessment.outgoings = assessment.cleanse data

  payload = assessment.outgoings.to_json
  request = assessment.get_request_uri('add_outgoings', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

Given('I add the following capital details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  # puts '{:bank_accounts=>[{:description=>"Bank acct 1", :value=>2999.0}, {:description=>"bank acct 2", :value=>0.0}, {:description=>"bank acct 3", :value=>0.0}], :non_liquid_capital=>[]}'

  data = { "#{string}" => table.hashes}
  assessment.capital = assessment.cleanse data

  payload = assessment.capital.to_json
  request = assessment.get_request_uri('add_capitals', payload, {'id' => assessment_id})
  requestBag.add(request)
  requestBag.process
  requestBag.reset
end

When('I retrieve the final assessment') do
  # Dispatch all API requests here.

  request = assessment.get_request_uri('get_assessment', {}, {'id' => assessment_id})
  requestBag.add(request)
  response = requestBag.process
  requestBag.reset

  puts response
end
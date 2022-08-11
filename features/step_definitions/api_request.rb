require_relative 'assessment'

assessment = Assessment.new

Given('I create an assessment with the following details:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:client_reference_id=>"NP-Full-1", :submission_date=>Mon, 10 May 2021, :proceeding_types=>{:ccms_codes=>["DA001", "SE013", "SE003"]}}'

  assessment.assessment = table.rows_hash

  puts assessment.assessment
end

Given('I add the following applicant details for the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:applicant=>{:date_of_birth=>Thu, 20 Dec 1979, :involvement_type=>"applicant", :has_partner_opponent=>false, :receives_qualifying_benefit=>false}}'

  assessment.applicant = {applicant: table.rows_hash}

  puts assessment.applicant
end

Given('I add the following dependent details for the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:dependants=>[{:date_of_birth=>Thu, 20 Dec 2018, :in_full_time_education=>false, :relationship=>"child_relative", :monthly_income=>0.0, :assets_value=>0.0}]}'

  assessment.dependants = { dependants: [table.rows_hash] }

  puts assessment.dependants
end

Given('I add the following other_income details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:other_incomes=>[{:source=>"friends_or_family", :payments=>[{:date=>"2021-05-10", :amount=>100.0, :client_id=>"id1"}, {:date=>"2021-04-10", :amount=>100.0, :client_id=>"id2"}, {:date=>"2021-03-10", :amount=>100.0, :client_id=>"id3"}]}]}'

  assessment.other_incomes = { other_incomes: {source: string, payments: [table.hashes]}}

  puts assessment.other_incomes
end

Given('I add the following irregular_income details in the current assessment:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:payments=>[{:income_type=>"student_loan", :frequency=>"annual", :amount=>120.0}]}'

  assessment.irregular_incomes = {payments: [table.hashes]}

  puts assessment.irregular_incomes
end

Given('I add the following outgoing details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:outgoings=>[{:name=>"rent_or_mortgage", :payments=>[{:payment_date=>"2021-05-10", :amount=>10.0, :client_id=>"id7"}, {:payment_date=>"2021-04-10", :amount=>10.0, :client_id=>"id8"}, {:payment_date=>"2021-03-10", :amount=>10.0, :client_id=>"id9"}]}]}'

  assessment.outgoings = {outgoings: [name: string, payments: table.hashes]}

  puts assessment.outgoings
end

Given('I add the following capital details for {string} in the current assessment:') do |string, table|
  # table is a Cucumber::MultilineArgument::DataTable

  puts '{:bank_accounts=>[{:description=>"Bank acct 1", :value=>2999.0}, {:description=>"bank acct 2", :value=>0.0}, {:description=>"bank acct 3", :value=>0.0}], :non_liquid_capital=>[]}'

  assessment.capital = {string: [table.hashes]}

  puts assessment.capital
end

When('I run the eligibility check on this data') do
  # Dispatch all API requests here.
  # table is a Cucumber::MultilineArgument::DataTable
  page.driver.header "Content-Type", "application/json"

  uri = assessment.get_uri(assessment.uri_sequence['assessment'])
  payload = assessment.assessment.to_json

  page.driver.post(uri, payload)
  
  puts payload
  puts page.body
end
Given('I am testing version {int}') do |int|
  page.driver.header "Accept", "application/json;version=#{int}"
end

Given('I am on the homepage somewhere:') do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  page.driver.header "Content-Type", "application/json"
  page.driver.post('/assessments', table.rows_hash.to_json)

  puts page.body
end

Then('I should see {string}') do |string|
  page.status_code.should eq 200
end

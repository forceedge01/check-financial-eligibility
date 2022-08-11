Given('I am using version {int} of the API') do |int|
  page.driver.header "Accept", "application/json;version=#{int}"
end

def post uri, payload, headers
	Capybara.page.driver.post('http://127.0.0.1:3000' + uri, payload, headers)

	Capybara.page.body
end

def get uri, headers
	Capybara.page.driver.get('http://127.0.0.1:3000' + uri, headers)

	Capybara.page.body
end

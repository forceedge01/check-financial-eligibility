Feature:
	abc

	Scenario: New project
	Given I am testing version 5
	And I create an assessment with the following details:
		| client_reference_id | HHH_CIT_12 |
		| submission_date     | 2022-01-24 |
	And I add the following applicant details for the current assessment:
		| date_of_birth               | 20/12/1979 |
		| involvement_type            | applicant  |
		| has_partner_opponent        | FALSE      |
		| receives_qualifying_benefit | FALSE      |
	And I add the following dependent details for the current assessment:
		| date_of_birth          | 20/12/2018     |
		| in_full_time_education | FALSE          |
		| relationship           | child_relative |
		| monthly_income         | 0.00           |
		| assets_value           | 0.00           |
	And I add the following dependent details for the current assessment:
		| date_of_birth          |  |
		| in_full_time_education |  |
		| relationship           |  |
		| monthly_income         |  |
		| assets_value           |  |
	Then I should see "Welcome aboard"

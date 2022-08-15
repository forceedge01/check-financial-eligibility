Feature:
    "1. Fully eligible, 2. No contribution"

    Scenario: Test that the correct output is produced for the following set of data.
        # Given I am using version 5 of the API
        And I create an assessment with the following details:
            | client_reference_id | HHH_CIT_2  |
            | submission_date     | 2022-01-24 |
            # | proceeding_types    | DA001;SE013;SE003 |
        And I add the following applicant details for the current assessment:
            | date_of_birth               | 1979-12-20 |
            | involvement_type            | applicant  |
            | has_partner_opponent        | false      |
            | receives_qualifying_benefit | false      |
        And I add the following capital details for "bank_accounts" in the current assessment:
            | description | value  |
            | Bank acc 1  | 2999.0 |
            | Bank acc 2  | 0      |
            | Bank acc 3  | 0      |
        And I add the following dependent details for the current assessment:
            | date_of_birth | in_full_time_education | relationship   | monthly_income | assets_value |
            | 2018-12-20    | FALSE                  | child_relative | 0.00           | 0.00         |
        And I add the following other_income details for "friends_and_family" in the current assessment:
            | date       | client_id | amount |
            | 10/05/2021 | id1       | 100.00 |
            | 10/04/2021 | id2       | 100.00 |
            | 10/03/2021 | id3       | 100.00 |
        And I add the following irregular_income details in the current assessment:
            | income_type  | frequency | amount |
            | student_loan | annual    | 120.00 |
        And I add the following outgoing details for "rent_or_mortgage" in the current assessment:
            | payment_date | housing_cost_type | client_id | amount |
            | 10/05/2021   | rent              | id7       | 10.00  |
            | 10/04/2021   | rent              | id8       | 10.00  |
            | 10/03/2021   | rent              | id9       | 10.00  |
        When I retrieve the final assessment


        Then I should see the following assement results:
            | sub-object             | attribute                         | value                 |
            | passported             |                                   | TRUE                  |
            | assessment_result      |                                   | partially_eligible    |
            | matter_types           | domestic_abuse                    | contribution_required |
            |                        | section8                          | ineligible            |
            | proceeding_type: DA001 | assessment_result                 | contribution_required |
            |                        | capital_lower_threshold           | 3,000.00              |
            |                        | capital_upper_threshold           | 999,999,999,999.00    |
            |                        | gross_income_upper_threshold      | 999,999,999,999.00    |
            |                        | disposable_income_lower_threshold | 315.00                |
            |                        | disposable_income_upper_threshold | 999,999,999,999.00    |
            | proceeding_type: SE013 | assessment_result                 | ineligible            |
            |                        | capital_lower_threshold           | 3,000.00              |
            |                        | capital_upper_threshold           | 8,000.00              |
            |                        | gross_income_upper_threshold      | 2,657.00              |
            |                        | disposable_income_lower_threshold | 315.00                |
            |                        | disposable_income_upper_threshold | 733.00                |
            | proceeding_type: SE003 | assessment_result                 | ineligible            |
            |                        | capital_lower_threshold           | 3,000.00              |
            |                        | capital_upper_threshold           | 8,000.00              |
            |                        | gross_income_upper_threshold      | 2,657.00              |
            |                        | disposable_income_lower_threshold | 315.00                |
            |                        | disposable_income_upper_threshold | 733.00                |
        And I should see the following gross_income_summary result:
            | sub-object             | attribute | value |
            | monthly_other_income   |           | 0.00  |
            | monthly_state_benefits |           | 0.00  |
            | monthly_student_loan   |           | 0.00  |
            | total_gross_income     |           | 0.00  |
        And I should see the following disposable_income_summary results:
            | sub-object          | attribute | value |
            | childcare           |           | 0.00  |
            | dependant_allowance |           | 0.00  |
            | maintenance         |           | 0.00  |
            | gross_housing_costs |           | 0.00  |
            | housing_benefit     |           | 0.00  |
            | net_housing_costs   |           | 0.00  |

            | total_outgoings_and_allowances |  | 0.00 |
            | total_disposable_income        |  | 0.00 |
            | income_contribution            |  | 0.00 |
        And I should see the following capital results:
            | sub-object                  | attribute | value              |
            | total_liquid                |           | 8,050.00           |
            | total_non_liquid            |           | 0.00               |
            | total_vehicle               |           | 0.00               |
            | total_mortgage_allowance    |           | 999,999,999,999.00 |
            | total_capital               |           | 8,050.00           |
            | pensioner_capital_disregard |           | 0.00               |
            | assessed_capital            |           | 8,050.00           |
            | capital_contribution        |           | 5,050.00           |
        And I should see the following monthly_income_equivalents results:
            | sub-object         | attribute | value |
            | friends_or_family  |           | 0.00  |
            | maintenance_in     |           | 0.00  |
            | property_or_lodger |           | 0.00  |
            | student_loan       |           | 0.00  |
            | pension            |           | 0.00  |
        And I should see the following monthly_outgoing_equivalents results:
            | sub-object       | attribute | value |
            | maintenance_out  |           | 0.00  |
            | child_care       |           | 0.00  |
            | rent_or_mortgage |           | 0.00  |
            | legal_aid        |           | 0.00  |
        And I should see the following deductions results:
            | sub-object                 | attribute | value |
            | dependants_allowance       |           | 0.00  |
            | disregarded_state_benefits |           | 0.00  |

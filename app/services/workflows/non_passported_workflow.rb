module Workflows
  class NonPassportedWorkflow < BaseWorkflowService
    def call
      return SelfEmployedWorkflow.call(assessment) if applicant.self_employed?

      collate_and_assess_gross_income
      return if gross_income_summary.ineligible?

      disposable_income_assessment
      return if disposable_income_summary.ineligible?

      collate_and_assess_capital
    end

  private

    def collate_and_assess_gross_income
      Collators::GrossIncomeCollator.call(assessment)
      Assessors::GrossIncomeAssessor.call(assessment)
    end

    def collate_outgoings
      Collators::OutgoingsCollator.call(assessment)
    end

    def disposable_income_assessment
      collate_outgoings
      Collators::DisposableIncomeCollator.call(assessment)
      Assessors::DisposableIncomeAssessor.call(assessment)
    end

    def collate_and_assess_capital
      data = Collators::CapitalCollator.call(assessment)
      capital_summary.update!(data)
      Assessors::CapitalAssessor.call(assessment)
    end
  end
end

module Decorators
  class GrossIncomeSummaryDecorator
    attr_reader :assessment

    def initialize(gross_income_summary)
      @record = gross_income_summary
    end

    def as_json
      return nil if @record.nil?

      {
        monthly_other_income: @record.monthly_other_income,
        monthly_state_benefits: @record.monthly_state_benefits,
        total_gross_income: @record.total_gross_income,
        upper_threshold: @record.upper_threshold,
        assessment_result: @record.assessment_result,
        state_benefits: @record.state_benefits.map { |sb| StateBenefitDecorator.new(sb).as_json },
        other_income: @record.other_income_sources.map { |oi| OtherIncomeSourceDecorator.new(oi).as_json }
      }
    end
  end
end

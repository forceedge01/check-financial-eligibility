module Collators
  class CapitalCollator < BaseWorkflowService
    def call
      {
        total_liquid: liquid_capital,
        total_non_liquid: non_liquid_capital,
        total_vehicle: vehicles,
        total_mortgage_allowance: property_maximum_mortgage_allowance_threshold,
        total_property: property,
        pensioner_capital_disregard: pensioner_capital_disregard,
        total_capital: total_capital,
        assessed_capital: assessed_capital,
        lower_threshold: lower_threshold,
        upper_threshold: upper_threshold,
        capital_contribution: capital_contribution
      }
    end

    private

    def assessed_capital
      total_capital - pensioner_capital_disregard
    end

    def total_capital
      @total_capital ||= liquid_capital + non_liquid_capital + vehicles + property
    end

    def liquid_capital
      @liquid_capital ||= Assessors::LiquidCapitalAssessor.call(assessment)
    end

    def non_liquid_capital
      @non_liquid_capital ||= Assessors::NonLiquidCapitalAssessor.call(assessment)
    end

    def property
      @property ||= Assessors::PropertyAssessor.call(assessment)
    end

    def vehicles
      @vehicles ||= Assessors::VehicleAssessor.call(assessment)
    end

    def property_maximum_mortgage_allowance_threshold
      Threshold.value_for(:property_maximum_mortgage_allowance, at: submission_date)
    end

    def pensioner_capital_disregard
      @pensioner_capital_disregard ||= Calculators::PensionerCapitalDisregardCalculator.new(assessment).value
    end

    def lower_threshold
      Threshold.value_for(:capital_lower, at: assessment.submission_date)
    end

    def upper_threshold
      Threshold.value_for(:capital_upper, at: assessment.submission_date)
    end

    def capital_contribution
      [0, assessed_capital - lower_threshold].max
    end
  end
end
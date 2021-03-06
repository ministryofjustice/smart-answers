require 'smartdown/model/answer/money'
require 'smartdown/model/answer/date'

module SmartdownPlugins
  module PayLeaveForParentsBirthAndAdoption

    def self.claim_date_maternity_allowance(date)
      build_date_answer(date.value - 14.weeks)
    end

    def self.earliest_start(date)
      build_date_answer(date.value - 11.weeks)
    end

    def self.earnings_test_start_date(date)
      build_date_answer(date.value - 66.weeks)
    end

    def self.end_of_14_week_maternity_allowance(date)
      build_date_answer(date.value + 14.weeks)
    end

    def self.end_of_additional_leave(date)
      build_date_answer(date.value + 52.weeks)
    end

    def self.end_of_additional_paternity_leave(date)
      build_date_answer(date.value + 1.year)
    end

    def self.end_of_additional_paternity_pay_from_leave(date)
      build_date_answer(date.value + 52.weeks)
    end

    def self.end_of_additional_paternity_pay_from_match_or_due_date(date)
      build_date_answer(date.value + 28.weeks)
    end

    def self.end_of_adoption_pay(date)
      build_date_answer(date.value + 39.weeks)
    end

    def self.end_of_maternity_allowance(date)
      build_date_answer(date.value + 28.weeks)
    end

    def self.end_of_maternity_pay(date)
      build_date_answer(date.value + 39.weeks)
    end

    def self.end_of_ordinary_leave(date)
      build_date_answer(date.value + 26.weeks)
    end

    def self.end_of_paternity_leave(date)
      build_date_answer(date.value + 2.weeks)
    end

    def self.end_of_shared_parental_leave(date)
      build_date_answer(date.value + 1.year)
    end

    def self.latest_pat_leave(date)
      build_date_answer(date.value + 56.days)
    end

    def self.lower_earnings_start(date)
      build_date_answer(date.value - 23.weeks)
    end

    def self.minimum_start_date(date)
      build_date_answer(date.value - 41.weeks)
    end

    def self.minimum_end_date(date)
      build_date_answer(date.value - 15.weeks)
    end

    def self.notice_adopt_leave(date)
      build_date_answer(date.value + 7.days)
    end

    def self.notice_date_sap(date)
      build_date_answer(date.value - 28.days)
    end

    def self.notice_date_smp(date)
      build_date_answer(date.value - 28.days)
    end

    def self.paternity_leave_notice_date(date)
      preceding_monday = date.value - (date.value.wday - 1).days
      build_date_answer(preceding_monday - 15.weeks)
    end

    def self.paternity_pay_notice_date(date_leave_2)
      build_date_answer(date_leave_2.value - 28.days)
    end

    def self.qualifying_week(date)
      build_date_answer(date.value - 15.weeks)
    end

    def self.rate_of_paternity_pay(salary_2)
      build_money_answer(nine_tenths_weekly_salary_capped_at_138_point_18(salary_2))
    end

    def self.rate_of_maternity_allowance(salary_1_66_weeks)
      build_money_answer(nine_tenths_weekly_salary_capped_at_138_point_18(salary_1_66_weeks))
    end

    def self.rate_of_sap(salary_1)
      build_money_answer(nine_tenths_weekly_salary_capped_at_138_point_18(salary_1))
    end

    def self.rate_of_shpp(salary)
      build_money_answer(nine_tenths_weekly_salary_capped_at_138_point_18(salary))
    end

    def self.rate_of_smp_6_weeks(salary_1)
      build_money_answer((salary_1.value / 52) * 0.9)
    end

    def self.rate_of_smp_33_weeks(salary_1)
      build_money_answer(nine_tenths_weekly_salary_capped_at_138_point_18(salary_1))
    end

    def self.start_of_additional_leave(date_leave_1)
      build_date_answer(date_leave_1.value + 26.weeks + 1.day)
    end

    def self.start_of_additional_paternity_leave(date)
      build_date_answer(date.value + 20.weeks)
    end

    def self.start_of_maternity_allowance(date)
      build_date_answer(date.value - 11.weeks)
    end

    def self.total_aspp(salary_2)
      build_money_answer(rate_of_paternity_pay(salary_2) * 26)
    end

    def self.total_maternity_allowance(salary_1_66_weeks)
      build_money_answer(rate_of_maternity_allowance(salary_1_66_weeks) * 39)
    end

    def self.total_sap(salary_1)
      build_money_answer(rate_of_sap(salary_1) * 39)
    end

    def self.total_smp(salary_1)
      build_money_answer((rate_of_smp_6_weeks(salary_1) * 6) + (rate_of_smp_33_weeks(salary_1) * 33))
    end

  private

    def self.build_date_answer(date)
      Smartdown::Model::Answer::Date.new(date.to_s)
    end

    def self.build_money_answer(amount)
      Smartdown::Model::Answer::Money.new(amount)
    end

    def self.nine_tenths_weekly_salary_capped_at_138_point_18(salary)
      weekly_salary = salary.value / 52
      rate = weekly_salary * 0.9
      rate < 138.18 ? rate : 138.18
    end
  end
end

module SmartdownAdapter
  class MoneyQuestionPresenter < SmartdownAdapter::QuestionPresenter
    def to_response(input)
      { amount: input }
    end

    def has_suffix_label?
      false
    end

  end
end

class Expense < ApplicationRecord
    validates :description, :company, :date, :responsible, :category, :amount_peso, :dollar_rate, presence: true
    validates :amount_peso, :dollar_rate, :equivalent_usd, :amount_usd, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

    RESPONSIBLES = ["Daniel", "Pablo", "Belén"]
    CATEGORIES = ["Gasto", "Inversión"]

    before_save :calculate_equivalent_usd

    private

    def calculate_equivalent_usd
        self.equivalent_usd = amount_peso / dollar_rate if dollar_rate.present? && amount_peso.present?
    end
end

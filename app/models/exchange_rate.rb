class ExchangeRate < ApplicationRecord
	extend FixerRates

	validates :base_currency, presence: true, length: {is: 3}, format: {with: /[A-Z]/}
	validates_presence_of :rates, :date

	def self.get_fixer_rates(from, to, base, other)
		response = []
		while from <= to 
			exchange_rate = self.check_fixer_rates(from, base, other)
			if exchange_rate.present?
				response << exchange_rate
			else
				fixer_rates_per_date(from)
				response << self.check_fixer_rates(from, base, other)
			end	
			from += 1.days
		end	
		response
	end

	def self.check_fixer_rates(date, base, other)
		rate = ExchangeRate.find_by_sql(["SELECT * FROM exchange_rates WHERE base_currency = ? AND date = ? AND rates->> ? IS NOT NULL", base, date, other])
		if rate.present?
			rr = rate.first 
			rate_hash = {}
			rate_hash["date"] = rr["date"]
			rate_hash["base"] = rr["base_currency"]
			rate_hash["rate"] = {other => rr["rates"][other]}
			rate_hash
		end	
	end
end

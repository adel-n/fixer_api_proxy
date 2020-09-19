class ExchangeRatesController < ApplicationController

	def get_exchange_rates
		from_date = params[:from]
		to_date = params[:to]
		base_currency = params[:base]
		other_currency = params[:other]
		unless (from_date.present? && to_date.present? && base_currency.present? && other_currency.present?) then render_missing_arguments(params) end
		unless valid_params?(from_date, to_date, base_currency, other_currency)	then render invalid_arguments end
		response = ExchangeRate.get_fixer_rates(from_date.to_date, to_date.to_date, base_currency, other_currency)
		render json: MultiJson.dump(response)
	end

	def render_missing_arguments(params)
		if !params[:from].present?
			message = "Missing start date"
		elsif !params[:to].present?
			message = "Missing to date"	
		elsif !params[:base].present?
			message = "Missing base currency"
		elsif !params[:other].present?
			message = "Missing other currency"
		end
		render json: { error: message, status: 400 }
	end

	def render_invalid_arguments
		render json: { error: "Invalid argument format", status: 400 }
	end

	def valid_params?(from_date, to_date, base_currency, other_currency)
		date_regex = /\d{4}\-\d{2}\-\d{2}/
		((base_currency.class == String && base_currency.length == 3)	&& (other_currency.class == String && other_currency.length == 3) && from_date.match?(date_regex) && to_date.match?(date_regex))
	end
end

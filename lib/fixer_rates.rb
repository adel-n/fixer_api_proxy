module FixerRates
	require "net/http"
	require "open-uri"

	def send_request_to_fixer(uri)
		retry_count = 3
		begin
			http = Net::HTTP.new(uri.host, uri.port)
			request = Net::HTTP::Get.new(uri.request_uri)
			response = http.request(request)
			JSON.parse(response.body)
		rescue Timeout::Error, Net::HTTPBadResponse, Net::HTTPUnauthorized, Net::ProtocolError => e
			if retry_count > 0
				retry_count -= 1
				sleep 5
				retry
			else
				raise
			end
		end					
	end

	def fixer_rates_per_date(date)
		uri = URI.parse("http://data.fixer.io/api/#{date}?access_key=#{api_key}")
		result = send_request_to_fixer(uri)
		if result["success"]
			create_fixer_rate(result)
		else
			p result
		end
	end

	def create_fixer_rate(result)
		ExchangeRate.create!(base_currency: result["base"], rates: result["rates"].as_json, date: result["date"])
	end

	private

	def api_key
		api_key = "83ff363fb12a3b4f699d14b8853988ef"
	end
end


# README

This is an only API Rails application that gets currency rates from the Fixer API.

Ruby version: 2.5.3

You can check the results with Postman by calling the following endpoint with GET.
http://localhost:3000/get_exchange_rates?base=EUR&from=2020-08-01&to=2020-08-05&other=USD

The params you need to set (all required):
  base: base currency
  other: other currency
  from: from date
  to: to date

Database will be generated based on the schema.

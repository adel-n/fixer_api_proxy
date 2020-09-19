class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
    	t.string :base_currency
    	t.jsonb :rates, default: {}
    	t.timestamp :date

      t.timestamps
    end
  end
end

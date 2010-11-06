# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090426015321) do

  create_table "quotes", :force => true do |t|
    t.integer  "stock_id"
    t.float    "ask"
    t.float    "bid"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "quotes", ["stock_id", "created_at"], :name => "index_quotes_on_stock_id_and_created_at"

  create_table "stocks", :force => true do |t|
    t.float    "weeks52_change_from_high"
    t.string   "moving_ave200days"
    t.string   "holdings_value"
    t.string   "weeks52_range"
    t.string   "eps_estimate_next_quarter"
    t.string   "ex_dividend_date"
    t.string   "dividend_per_share"
    t.string   "price_paid"
    t.string   "symbol"
    t.string   "eps_estimate_next_year"
    t.string   "moving_ave50days"
    t.string   "price_per_eps_estimate_current_year"
    t.string   "weeks52_change_from_low"
    t.string   "shares_owned"
    t.string   "notes"
    t.string   "dividend_yield"
    t.string   "ebitda"
    t.string   "market_cap"
    t.string   "price_per_eps_estimate_next_year"
    t.string   "trade_date"
    t.string   "holdings_gain_percent"
    t.string   "book_value"
    t.string   "commission"
    t.string   "stock_exchange"
    t.string   "dividend_pay_date"
    t.string   "low_limit"
    t.string   "short_ratio"
    t.string   "weeks52_change_percent_from_low"
    t.string   "moving_ave200days_change_percent_from"
    t.string   "price_per_book"
    t.string   "one_year_target_price"
    t.string   "annualized_gain"
    t.string   "moving_ave200days_change_from"
    t.string   "high_limit"
    t.string   "day_value_change"
    t.string   "name"
    t.string   "moving_ave50days_change_percent_from"
    t.string   "weeks52_change_percent_from_high"
    t.string   "pe_ratio"
    t.string   "earnings_per_share"
    t.string   "peg_ratio"
    t.string   "moving_ave50days_change_from"
    t.string   "eps_estimate_current_year"
    t.string   "price_per_sales"
    t.string   "holdings_gain"
    t.string   "volume"
    t.float    "change"
    t.float    "change_points"
    t.float    "open"
    t.float    "day_low"
    t.integer  "average_daily_volume"
    t.float    "last_trade"
    t.float    "bid"
    t.float    "change_percent"
    t.float    "day_high"
    t.integer  "short_stock_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

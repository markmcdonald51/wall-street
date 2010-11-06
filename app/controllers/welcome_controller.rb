class WelcomeController < ApplicationController
  def compute
    symbol = 'fas'
    @start_date = Chronic.parse('may 2, 2009')
    @starting_amount = '25000'
    
    @etf = Stock.find_by_symbol(symbol)
  end

end

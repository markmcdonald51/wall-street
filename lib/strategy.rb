module Strategy

  class FillTheGap
    include Strategy
    
    attr_accessor :stock, :date, :stop_loss_percentage
      
    def initialize(symbol, date, stop_loss_percentage = -3.0)
      @stock = Stock.find_by_symbol(symbol)
      @date = Chronic.parse(date)
      @stop_loss_percentage = stop_loss_percentage
    end
    
    def fill_the_gap
      if play(stock)
      else
        play(stock.inverse_etf)
      end 
    end
    
    def play(stock)
      puts "----------------------------------------------"
      puts "Starting Stock #{stock.symbol}"
      @previous_close_quote, @quotes, @open_quote = get_vars_for_date(stock)
      @precent_diff = ((@open_quote.ask - @previous_close_quote.ask) / @open_quote.ask) * 100
      puts "close #{@previous_close_quote.ask}"
      puts "open #{@open_quote.ask}"
      puts "Percent diff: #{@precent_diff}"
     
      if (@stop_loss_percentage < @precent_diff)
        puts "Sit out on #{stock.symbol}  #{@precent_diff.to_f} >  #{@stop_loss_percentage} "      
        return false
      end

      puts "Buying #{stock.label}"
      @buy_in_price = @open_quote.ask
      @stop_loss = calc_stop_loss_amount(@buy_in_price, @stop_loss_percentage)
      
      @stop_gain_loss_amount = @buy_in_price * 1.01
      
      puts "Bought in at: #{@buy_in_price}" 
      puts "Stop loss: #{@stop_loss}"
      puts "Must get above #{@stop_gain_loss_amount } for 1% saftey stop"
      
      gain_loss_set = false
      
      @quotes.each do |q|
        print  "#{q.ask} "
        next if q.ask == 0.00
        
        if q.ask <= @stop_loss
          puts "-----------------"
          puts "stopped out at #{@stop_loss} at #{q.date}"
          puts "------------------------------------------------------"
          puts "------------------- GAIN LOSS -----------------------"
          puts gain_loss_percentage 
          
          break
        
        elsif ((q.ask >  @stop_gain_loss_amount) && (gain_loss_set != true))
          @stop_loss = @stop_gain_loss_amount.to_f
          puts "Got above 1% #{@stop_gain_loss_amount}"
          gain_loss_set = true
          
        elsif gain_loss_set == true and greater_than_percent?(q.ask, @stop_loss, 1.1)        
          @stop_loss = calc_stop_loss_amount(q.ask, -1.1)   
          puts "\n-------------------------------"
          puts "! ANOTHER 1 Percent: #{q.ask} !"
          puts "Reseting stoploss to #{@stop_loss}"
        end  
      end
      
      return true
    end
  end 
  
  def get_vars_for_date(stock)
    d = 1.business_day.ago(date).to_date.to_s( :article)
    previous_close_quote = stock.quotes.for_date(d).last
    quotes = stock.quotes.for_date(date).intraday
    open_quote = quotes.first 
    [previous_close_quote, quotes, open_quote]     
  end
  
  def calc_stop_loss_amount(buy, percent)
    buy - (((percent * -1) * 0.01) * buy)   
  end
  
  def greater_than_percent?(a,b,percent)
     (((a.to_f - b.to_f) / a.to_f) * 100) > percent    
  end
  
  def gain_loss_percentage
    puts "bought at: #{@buy_in_price}"
    puts "sold at: #{@stop_loss}"
   (@stop_loss - @buy_in_price) /   @buy_in_price * 100
     
  end  
     

end

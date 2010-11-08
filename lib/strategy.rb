module Strategy
  include ActionView::Helpers::NumberHelper

  def self.included(recipient)
    recipient.class_eval  <<-END     
      attr_accessor :stock, :date, :stop_loss_percentage, :quotes, :open_quote,
        :buy_in_price, :stop_gain_loss_amount, :gain_loss_perc, :notes, 
        :stop_loss,:buy_when_up_percentage, :trailing_stop_percentage

      def initialize(*args)
        options = {
          :symbol =>'fas', 
          :date => 'dec 10, 2009', 
          :buy_when_up_percentage => 1.1,
          :trailing_stop_percentage => 1.1,
          :stop_loss_percentage => -3}.merge(args.extract_options! )
        
        @stock = Stock.find_by_symbol(options[:symbol])
        @date = Chronic.parse(options[:date])
        @stop_loss_percentage = options[:stop_loss_percentage]
        @buy_when_up_percentage = options[:buy_when_up_percentage]
        @trailing_stop_percentage = options[:trailing_stop_percentage]
        @notes = ''
      end
        
    END
  end
  
    
  class UpAndAway
    include Strategy
    attr_accessor :buy_when_up_percentage

    def up_and_away
     play(stock)
     # if play(stock)
     # else
     #   play(stock.inverse_etf)
     # end 
    end
    
 
    def play(stock)
      @previous_close_quote, @quotes, @open_quote = get_vars_for_date(stock)

      puts "open: #{@open_quote.ask}"
      
      lowest_price = nil
      highest_price = nil
      #buy_in_price = nil
      
      @quotes.each do |q|
        lowest_price   ||= q.ask
        highest_price  ||= q.ask
        lowest_price = (lowest_price > q.ask)   ? q.ask : lowest_price 
        highest_price = (highest_price < q.ask) ? q.ask : highest_price
        puts "--------------------------------"

        
        precent_diff = percentage_diff(q.ask, open_quote.ask)
        puts  "Cur Price: #{@precent_diff}% (#{q.ask})" 
        puts "lowest price: #{lowest_price}"
        puts "highest price: #{highest_price}"
        
        if (@buy_in_price.blank? and precent_diff >= buy_when_up_percentage)
          @buy_in_price = q.ask
          puts "\nBought in at:  #{@buy_in_price}\n"
          @stop_loss = calc_stop_loss_amount(@buy_in_price,  stop_loss_percentage) 
        end
       
        
        if @buy_in_price
          #if @stop_loss_percentage >= percentage_diff(q.ask, @buy_in_price) || q.ask <= @stop_loss

          puts "Gain/Loss: #{percentage_diff(q.ask, @buy_in_price)}"
          puts "Stop Loss: #{@stop_loss} (#{@stop_loss_percentage})"
          if q.ask <= @stop_loss
            puts '-----------------------------------------------'
            puts '---------------- RESULTS-----------------------'
            puts "#{percentage_diff(@buy_in_price, q.ask)} <= #{@stop_loss_percentage }"
            puts "Bought in @ #{@buy_in_price}"
            puts "Stopped Out @ #{q.ask}"
            puts "Gain/Loss: #{percentage_diff(q.ask, @buy_in_price)}"
            puts "Stop Loss: #{@stop_loss} (#{@stop_loss_percentage})"
            return false
            
          elsif greater_than_percent?(q.ask, stop_loss,  trailing_stop_percentage )
            @stop_loss = calc_stop_loss_amount(q.ask,  trailing_stop_percentage ) 
          
          end
        end  
      end
    end 
  end  


  class FillTheGap
    include Strategy

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
      #@precent_diff = ((@open_quote.ask - @previous_close_quote.ask) / @open_quote.ask) * 100
      @precent_diff = percentage_diff(@open_quote.ask, @previous_close_quote.ask)
      puts "close #{@previous_close_quote.ask}"
      puts "open #{@open_quote.ask}"
      puts "Percent diff: #{@precent_diff}"
     
      if (@stop_loss_percentage < @precent_diff)
        @notes << "\nSit out on #{stock.symbol}  #{@precent_diff.to_f} >  #{@stop_loss_percentage} \n"      
        return false
      end

      @notes << "\nBuying #{stock.label}\n"
      @buy_in_price = @open_quote.ask
      @stop_loss = calc_stop_loss_amount(@buy_in_price, @stop_loss_percentage)
      
      @stop_gain_loss_amount = @buy_in_price * 1.01
      
      @notes << "Bought in at: #{@buy_in_price}\n" 
      @notes <<  "Stop loss: #{@stop_loss}\n"
      @notes <<  "Must get above #{@stop_gain_loss_amount } for 1% safety stop\n"
      
      gain_loss_set = false
      
      @quotes.each do |q|
        @notes <<  "#{q.ask}\n"
        next if q.ask == 0.00
        
        if q.ask <= @stop_loss
          @notes <<  "\n-----------------\n"
          @notes <<  "stopped out at #{@stop_loss} at #{q.date}\n"
          @notes <<  "------------------------------------------------------\n"
          @notes <<  "------------------- GAIN LOSS -----------------------\n"
          @notes <<  gain_loss_percentage.to_s 
          @gain_loss_perc = gain_loss_percentage
          
          break
        
        elsif ((q.ask >  @stop_gain_loss_amount) && (gain_loss_set != true))
          @stop_loss = @stop_gain_loss_amount.to_f
          @notes << "Got above 1% #{@stop_gain_loss_amount}"
          gain_loss_set = true
          
        elsif gain_loss_set == true and greater_than_percent?(q.ask, @stop_loss, 1.1)        
          @stop_loss = calc_stop_loss_amount(q.ask, -1.1)   
          @notes <<  "\n-------------------------------\n"
          @notes <<  "! ANOTHER 1 Percent: #{q.ask} !\n"
          @notes << "Reseting stoploss to #{@stop_loss}\n"
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
  
  def percentage_diff(a,b)
    number_with_precision( ((a.to_f - b.to_f) / a.to_f) * 100, :precision => 2).to_f      
  end  

end

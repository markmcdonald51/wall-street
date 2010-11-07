class WelcomeController < ApplicationController
  def compute
    get_vars   
    if @symbol   
      @strategy = Strategy::FillTheGap.new(:symbol => @symbol, :date => @start_date) 
      @strategy.fill_the_gap
      @total_buyin_with_leverage = @current_amount.to_f  * @leverage.to_f
      @number_shares_bought = @total_buyin_with_leverage.to_f  / @strategy.buy_in_price.to_f 
      
      debugger
      if @strategy.gain_loss_perc
        @dollar_gain_loss =  @total_buyin_with_leverage.to_f * @strategy.gain_loss_perc.to_f / 100
        @current_amount =  @current_amount.to_f  + @dollar_gain_loss.to_f
        session[:current_amount] = @current_amount.to_f
      end
     
    end
  end
  
  
  def get_vars 
    [:symbol, :starting_amount, :leverage, :start_date, :current_amount].each do |f|
      if (v = params[f])
        session[f] =  v
      end  
      session[:current_amount] ||= session[:starting_amount]
      instance_variable_set(:"@#{f.to_s}", session[f])
    end
  end

end

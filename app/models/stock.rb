class Stock < ActiveRecord::Base

  has_many :quotes
  attr_accessor :quote_type
  before_create :get_stats
  #after_create :get_history

  validates_presence_of :symbol
  validates_uniqueness_of :symbol
  
  belongs_to :inverse_etf, :class_name => 'Stock'
  
  def label
    "#{symbol.upcase}/#{name.titleize}" 
  end
   
  def realtime
    YahooFinance::get_quotes(YahooFinance::RealTimeQuote, symbol ) do |qt|
      #return  realime_quote = quotes.build(:ask => qt.ask, :bid => qt.bid)
      return quotes.new(:ask => qt.ask, :bid => qt.bid, :date => Time.new)
    end
  end
  
  def get_stats
    # Get the quotes from Yahoo! Finance.  The get_quotes method call
    # returns a Hash containing one quote object of type "quote_type" for
    # each symbol in "quote_symbols".  If a block is given, it will be
    # called with the quote object (as in the example below).
    YahooFinance::get_quotes(YahooFinance::ExtendedQuote, symbol ) do |qt|
        # puts "QUOTING: #{qt.symbol}"
        # puts qt.instance_variables
        qt.instance_variables.each do |f| 
          next if f =~ /formathash/ 
          method_name = f.delete('@') 
          self.send("#{method_name.underscore}=", qt.send(method_name))  if self.respond_to? method_name.underscore
        end
      end
  end

  def get_history
    YahooFinance::get_historical_quotes_days( symbol, 360 ) do |row|
      quote_date = row.first
      quote = self.quotes.find_or_create_by_date(quote_date)
      quote.update_attributes(
        :open => row[1],
        :high => row[2],
        :low  => row[3],
        :close => row[4],
        :volume => row[5] )

    end   
  end
end

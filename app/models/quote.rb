class Quote < ActiveRecord::Base
  belongs_to :stock

  default_scope :order => 'date asc'

 # '11am = 4am PST'


 # named_scope :pre_market, lambda {|search_date| {
 #   :conditions => { :date  => ((Chronic.parse(search_date).to_date.at_beginning_of_day) + 4.hours + 30.minutes)..((Chronic.parse(search_date).to_date.at_beginning_of_day) + 6.hours + 30.minutes) } }}


  named_scope :for_date, lambda{|search_date|{ :conditions => [
    'date > ? and date < ?', Chronic.parse(search_date.to_s).to_date.beginning_of_day, 
                             Chronic.parse(search_date.to_s).to_date.end_of_day] }} do
      def for_hour(hour)
        find(:all, :conditions => ['hour(date) = ?', hour] )
      end

      def pre_market            
       find(:all, :conditions => ['hour(date) < ? ', '13:30'])
        #find(:all, :conditions => [' and date  < ?', 
        #  self.at_beginning_of_day + 6.hours + 30.minutes,
        #  self.at_beginning_of_day + 12.hours + 30.minutes ])
      end

      def intraday
        find(:all, :conditions => ['hour(date) > ? and hour(date) < ?', 
          '13:30', '20:00'])
      end

      def after_hours
        find(:all, :conditions => ['hour(date) > ? ', '20:00'])
      end
   end

end

class Quote < ActiveRecord::Base
  belongs_to :stock

  default_scope :order => 'date asc'

  named_scope :for_date, lambda{|search_date|{ :conditions => [
    'date > ? and date < ?', Chronic.parse(search_date.to_s).to_date.beginning_of_day, 
                             Chronic.parse(search_date.to_s).to_date.end_of_day] }} do
      def for_hour(hour)
        find(:all, :conditions => ['hour(date) = ?', hour] )
      end

      def pre_market            
       find(:all, :conditions => ['hour(date) < ? ', '13:30'])
      end

      def intraday
        find(:all, :conditions => ['hour(date) > ? and hour(date) < ?', '13:30', '20:00'])
      end

      def after_hours
        find(:all, :conditions => ['hour(date) > ? ', '20:00'])
      end
   end

end

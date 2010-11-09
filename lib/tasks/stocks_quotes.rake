
namespace :stock do
  desc "Create blank directories if they don't already exist"
  task (:get_quotes  => :environment) do  
    symbols = %w(sso fas faz bgz ery tza tna erx bgu mwn tpy edz skf eslr ure iyr xlf gld)

    symbols.each do |s|
      stock = Stock.find_or_create_by_symbol(s)
      stock.quotes << stock.realtime
    end
    
  end
end


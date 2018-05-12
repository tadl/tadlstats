desc "fetch graph data and store in cache"
task :update_graphs => :environment do
    require 'open-uri'
    require 'csv'

    graphs = {
        "circ_graph" => "https://www.tadl.org/stats/data/circ-weekly.csv",
        "wireless_graph" => "https://www.tadl.org/stats/data/wireless-weekly.csv",
        "pubcomp_graph" => "https://www.tadl.org/stats/data/pubcomp-weekly.csv",
        "newusers_graph" => "https://www.tadl.org/stats/data/newusers-weekly.csv"
    }

    graphs.each do |key, link|
        puts "processing " + key + "... "
        csv = CSV.parse(open(link).read(), :headers => false)
        
        if key == "circ_graph"
            puts key
        end

    end
    Rails.cache.write('charts_updated', Time.now)

end

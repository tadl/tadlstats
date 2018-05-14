desc "fetch graph data and store in cache"
task :update_graphs => :environment do
    require 'open-uri'
    require 'csv'

    graphs = {
        "circ_graph" => Settings.circ_weekly_url,
        "wireless_graph" => Settings.wireless_weekly_url,
        "pubcomp_graph" => Settings.pubcomp_weekly_url,
        "newusers_graph" => Settings.newusers_weekly_url
    }

    graphs.each do |key, link|
        puts "processing " + key + "... "
        csv = CSV.parse(open(link).read(), :headers => false)
        
        if key == "circ_graph"
        end

    end
    Rails.cache.write('charts_updated', Time.now)

end

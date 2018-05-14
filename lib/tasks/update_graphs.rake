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
            @circ_hash = Hash.new
            @circ_hash['TADL-WOOD'] = Array.new
            @circ_hash['TADL-EBB'] = Array.new
            @circ_hash['TADL-FLPL'] = Array.new
            @circ_hash['TADL-KBL'] = Array.new
            @circ_hash['TADL-IPL'] = Array.new
            @circ_hash['TADL-PCL'] = Array.new
            @circ_hash['circdates'] = Array.new

            csv.each do |row|
                location, date, count = row
                if location == "TADL-WOOD"
                    @circ_hash['circdates'].push(date)
                end
                @circ_hash[location].push(count)
            end

            Rails.cache.write(key, @circ_hash)
        end

        if key == "wireless_graph"
        end

        if key == "pubcomp_graph"
        end

        if key == "newusers_graph"
        end

    end
    Rails.cache.write('charts_updated', Time.now)

end

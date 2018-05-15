desc "fetch graph data and store in cache"
task :graphs => :environment do
    require 'open-uri'
    require 'csv'

    graphs = {
        "circ_weekly" => Settings.circ_weekly_url,
        "wireless_weekly" => Settings.wireless_weekly_url,
        "pubcomp_weekly" => Settings.pubcomp_weekly_url,
        "newusers_weekly" => Settings.newusers_weekly_url
    }

    graphs.each do |key, link|
        puts "processing " + key + "... "
        csv = CSV.parse(open(link).read(), :headers => false)

        if key == "circ_weekly"
            @circ_hash = Hash.new
            Settings.locations.each do |loc|
                @circ_hash[loc.evergreen_name] = Array.new
            end
            @circ_hash['graphdates'] = Array.new

            csv.each do |row|
                location, date, count = row
                if location == Settings.locations.first[:evergreen_name]
                    @circ_hash['graphdates'].push(date)
                end
                @circ_hash[location].push(count)

            end


            Rails.cache.write(key, @circ_hash)
        end

        if key == "pubcomp_weekly"
            @pubcomp_hash = Hash.new
            Settings.locations.each do |location|
                @pubcomp_hash[location.short_name] = Array.new
            end
            @pubcomp_hash['graphdates'] = Array.new

            csv.each do |row|
                location, date, sessions, seconds = row
                if location == Settings.locations.first[:short_name]
                    @pubcomp_hash['graphdates'].push(date)
                end
                @pubcomp_hash[location].push([sessions, seconds])
            end
            Rails.cache.write(key, @pubcomp_hash)
        end

        if key == "newusers_weekly"
            @newusers_hash = Hash.new
            Settings.locations.each do |location|
                @newusers_hash[location.evergreen_name] = Array.new
            end
            @newusers_hash['graphdates'] = Array.new

            csv.each do |row|
                location, date, count = row

                @newusers_hash[location].push([date, count])
            end
            Rails.cache.write(key, @newusers_hash)

            # debug
            puts "wood: " + @newusers_hash['TADL-WOOD'].count.to_s
            puts "ebb: " + @newusers_hash['TADL-EBB'].count.to_s
            puts "flpl: " + @newusers_hash['TADL-FLPL'].count.to_s
            puts "ipl: " + @newusers_hash['TADL-IPL'].count.to_s
            puts "kbl: " + @newusers_hash['TADL-KBL'].count.to_s
            puts "pcl: " + @newusers_hash['TADL-PCL'].count.to_s
            puts "dates array: " + @newusers_hash['graphdates'].count.to_s
            puts @newusers_hash.inspect
        end

        if key == "wireless_weekly"
        end

    end
    Rails.cache.write('charts_updated', Time.now)

end

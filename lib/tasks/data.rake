namespace :data do
    desc "Load data for graphs"
    task graphs: :environment do
        require 'open-uri'
        require 'csv'

        graphs = {
            "circ_weekly" => Settings.circ_weekly_url,
            "wireless_weekly" => Settings.wireless_weekly_url,
            "pubcomp_weekly" => Settings.pubcomp_weekly_url,
            "newusers_weekly" => Settings.newusers_weekly_url
        }

        graphs.each do |key, link|
            puts "[graphs task] processing " + key + "... "
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
            end

            if key == "wireless_weekly"
            end

        end

        Rails.cache.write('charts_updated', Time.now)
    end


    desc "fetch top ten lists and store them in cache"
    task lists: :environment do
        require 'open-uri'
        require 'csv'

        lists = {
            "books" => Settings.top10books_url,
            "movies" => Settings.top10movies_url,
            "music" => Settings.top10music_url
        }

        detailurl = Settings.item_details_prefix
        topten = {}

        lists.each do |key, link|
            puts "[lists task] processing " + key + "... "
            csv = CSV.parse(open(link).read(), :headers => false)
            topten[key] = Array.new

            csv.each do |row|
                id, title, author, year, abstract, count = row
                response = JSON.parse(open(detailurl + id).read)

                if response['author'].include? ","
                    authortmp = response['author'].split(", ")
                    author = authortmp[1] + " " + authortmp[0]
                else
                    author = response['author']
                end

                title = response['title']
                year = response['record_year']
                abstract = response['abstract']
                contents = response['contents']

                topten[key].push([id, count, author, title, year, abstract, contents])
            end

            Rails.cache.write(key, topten[key])
        end

        Rails.cache.write('lists_updated', Time.now)
    end


    desc "stats"
    task stats: :environment do
            puts "[stats task] ..."
    end


    desc "All"
    task all: ["data:graphs", "data:lists", "data:stats"]
end

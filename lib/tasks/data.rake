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

                Settings.locations.each do |l|
                    @circ_hash[l.evergreen_name] = Array.new
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
                @dates_hash = Hash.new
                @pubcomp_hash = Hash.new
                @pubcomp_hash['sessions'] = Hash.new
                @pubcomp_hash['seconds'] = Hash.new

                Settings.locations.each do |l|
                    @pubcomp_hash['sessions'][l.short_name] = Array.new
                    @pubcomp_hash['seconds'][l.short_name] = Array.new
                end

                csv.each do |row|
                    location, date, sessions, seconds = row

                    if !@dates_hash.key?(date)
                        @dates_hash[date] = Hash.new
                    end

                    @dates_hash[date].store(location, [sessions, seconds])
                end

                Settings.locations.each do |l|
                    @pubcomp_hash[l.short_name] = Array.new
                end

                @pubcomp_hash['graphdates'] = Array.new

                @dates_hash.each do |d, e|
                    @pubcomp_hash['graphdates'].push(d)

                    Settings.locations.each do |l|
                        if @dates_hash[d][l.short_name].nil?
                            @pubcomp_hash['sessions'][l.short_name].push(0)
                            @pubcomp_hash['seconds'][l.short_name].push(0)
                        else
                            @pubcomp_hash['sessions'][l.short_name].push(e[l.short_name][0])
                            @pubcomp_hash['seconds'][l.short_name].push(e[l.short_name][1])
                        end
                    end
                end

                Rails.cache.write(key, @pubcomp_hash)
            end

            if key == "newusers_weekly"
                @dates_hash = Hash.new
                @newusers_hash = Hash.new

                csv.each do |row|
                    location, date, count = row

                    if !@dates_hash.key?(date)
                        @dates_hash[date] = Hash.new
                    end

                    @dates_hash[date].store(location, count)
                end

                Settings.locations.each do |l|
                    @newusers_hash[l.evergreen_name] = Array.new
                end

                @newusers_hash['graphdates'] = Array.new

                @dates_hash.each do |d, e|
                    @newusers_hash['graphdates'].push(d)

                    Settings.locations.each do |l|
                        if @dates_hash[d][l.evergreen_name].nil?
                            @newusers_hash[l.evergreen_name].push(0)
                        else
                            @newusers_hash[l.evergreen_name].push(e[l.evergreen_name])
                        end

                    end

                end

                Rails.cache.write(key, @newusers_hash)
            end

            if key == "wireless_weekly"
                @dates_hash = Hash.new
                @wireless_hash = Hash.new

                csv.each do |row|
                    location, date, count = row

                    if !@dates_hash.key?(date)
                        @dates_hash[date] = Hash.new
                    end

                    @dates_hash[date].store(location, count)
                end

                Settings.locations.each do |l|
                    @wireless_hash[l.short_name] = Array.new
                end

                @wireless_hash['graphdates'] = Array.new

                @dates_hash.each do |d, e|
                    @wireless_hash['graphdates'].push(d)

                    Settings.locations.each do |l|
                        if @dates_hash[d][l.short_name].nil?
                            @wireless_hash[l.short_name].push(0)
                        else
                            @wireless_hash[l.short_name].push(e[l.short_name])
                        end

                    end

                end

                Rails.cache.write(key, @wireless_hash)
            end

        end

        Rails.cache.write('graphs_updated', Time.now)
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
        topten = Hash.new

        lists.each do |key, link|
            puts "[lists task] processing " + key + "... "
            csv = CSV.parse(open(link).read(), :headers => false)
            topten[key] = Hash.new

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
                titlesplit = title.split(" : ")
                title = titlesplit[0]
                year = response['record_year']
                abstract = response['abstract']
                contents = response['contents']

                topten[key].store(id, {:count => count, :author => author, :title => title, :year => year, :abstract => abstract, :contents => contents})
            end

            Rails.cache.write("topten" + key, topten[key])
        end

        Rails.cache.write('lists_updated', Time.now)
    end


    desc "stats"
    task stats: :environment do
        require 'open-uri'
        require 'csv'

        files = {
            "circ_by_type_12months" => Settings.circ_by_type_12months_url,
            "collection_size" => Settings.collection_size_url,
            "copies_added_12months" => Settings.copies_added_12months_url,
            "copies_withdrawn_12months" => Settings.copies_withdrawn_12months_url,
            "newusers_12months" => Settings.newusers_12months_url,
            "pubcomp_12months" => Settings.pubcomp_12months_url,
            "soft_stat_questions_12months" => Settings.soft_stat_questions_12months_url,
            "wireless_12months" => Settings.wireless_12months_url
        }

        @statsdata = Hash.new

        files.each do |file, link|
            puts "[stats task] processing " + file + "..."
            csv = CSV.parse(open(link).read(), :headers => false)
            @statsdata[file] = Hash.new

            if file == "circ_by_type_12months"
                csv.each do |row|
                    loc, type, count = row
                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end
                    @statsdata[file][loc].store(type, count)
                end

                @total = Hash.new(0)

                Settings.locations.each do |l|
                    @statsdata[file][l.evergreen_name].each {|key, count| @total[key] += count.to_i}
                end

                @statsdata[file]["total"] = @total
            end

            if file == "collection_size"
                csv.each do |row|
                    loc, type, count = row

                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end

                    @statsdata[file][loc].store(type, count)
                end

                @total = Hash.new(0)

                Settings.locations.each do |l|
                    @statsdata[file][l.evergreen_name].each {|key, count| @total[key] += count.to_i}
                end

                @statsdata[file]["total"] = @total
            end

            if file == "copies_added_12months"
                csv.each do |row|
                    loc, type, count = row

                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end

                    @statsdata[file][loc].store(type, count)
                end

                @total = Hash.new(0)

                Settings.locations.each do |l|
                    @statsdata[file][l.evergreen_name].each {|key, count| @total[key] += count.to_i}
                end

                @statsdata[file]["total"] = @total
            end

            if file == "copies_withdrawn_12months"
                csv.each do |row|
                    loc, type, count = row

                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end

                    @statsdata[file][loc].store(type, count)
                end

                @total = Hash.new(0)

                Settings.locations.each do |l|
                    @statsdata[file][l.evergreen_name].each {|key, count| @total[key] += count.to_i}
                end

                @statsdata[file]["total"] = @total
            end

            if file == "newusers_12months"
                @total = 0

                csv.each do |row|
                    loc, count = row
                    @total += count.to_i
                    @statsdata[file].store(loc, count)
                end

                @statsdata[file]["total"] = @total
            end

            if file == "pubcomp_12months"

                csv.each do |row|
                    loc, sessions, seconds, users = row

                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end

                    @statsdata[file].store(loc, {:sessions => sessions, :seconds => seconds, :users => users})
                end

                if @statsdata[file].key?("tadl")
                    @statsdata[file]["total"] = @statsdata[file]["tadl"]
                end

            end

            if file == "soft_stat_questions_12months"
                @total = 0

                csv.each do |row|
                    loc, count = row
                    @total += count.to_i
                    @statsdata[file].store(loc, count)
                end

                @statsdata[file]["total"] = @total
            end

            if file == "wireless_12months"
                csv.each do |row|
                    loc, count, devices = row
                    if !@statsdata[file].key?(loc)
                        @statsdata[file][loc] = Hash.new
                    end
                    @statsdata[file][loc].store(count, devices)
                end

            end

        end

        Rails.cache.write('stats_data', @statsdata)
        Rails.cache.write('stats_updated', Time.now)
    end


    desc "All"
    task all: ["data:graphs", "data:lists", "data:stats"]
end

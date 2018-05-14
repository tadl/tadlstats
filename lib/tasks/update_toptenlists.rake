desc "fetch top ten lists and store them in cache"
task :update_toptenlists => :environment do
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
        puts "processing " + key + "... "
        csv = CSV.parse(open(link).read(), :headers => false)
        topten[key] = []

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
        puts topten[key].inspect

        Rails.cache.write(key, topten[key])

    end
    Rails.cache.write('lists_updated', Time.now)

end

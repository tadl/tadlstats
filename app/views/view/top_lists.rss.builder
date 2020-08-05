xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Traverse Area District Library - Top Ten " + @list_name
    xml.description "The top ten " + @list_name + ' checked out from Traverse Area District Library in the last 30 days'
    xml.link root_url

    @list.each do |item|
      xml.item do
        xml.title item['title'] + ' - ' + item['author']
        xml.description item['abstract']
        xml.link item['link']
        xml.guid item['link']
        xml.enclosure :url=> item['cover'], :length=> 500, :type => 'img\jpg'
      end
    end
  end
end
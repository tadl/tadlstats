xml.instruct! :xml, :version => "1.0"
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Traverse Area District Library - Top Ten " + @list_name
    xml.description "The top ten " + @list_name.downcase + ' checked out from Traverse Area District Library in the last 30 days'
    xml.link 'https://www.tadl.org'
    xml.image :url => 'https://www.tadl.org/wp-content/uploads/2016/06/logo-horizontal-web-e1468248675904.png', :title => 'Traverse Area District Library', :link => "https://www.tadl.org" 
    if @list_name == 'Books'
      @list.each do |item|
        xml.item do
          xml.title item['title'] + ' - ' + item['author']
          xml.description item['abstract']
          xml.link item['link']
          xml.guid item['link']
          xml.enclosure :url=> item['cover'], :length=> 500, :type => 'image/jpg'
        end
      end
    elsif @list_name == 'Movies'
      @list.each do |item|
        xml.item do
          xml.title item['title']
          xml.description item['abstract']
          xml.link item['link']
          xml.guid item['link']
          xml.enclosure :url=> item['cover'], :length=> 500, :type => 'image/jpg'
        end
      end
    elsif @list_name == 'Music'
      @list.each do |item|
        xml.item do
          xml.title item['author'] + ' - ' + item['title']
          xml.description item['contents']
          xml.link item['link']
          xml.guid item['link']
          xml.enclosure :url=> item['cover'], :length=> 500, :type => 'image/jpg'
        end
      end
    end
  end
end
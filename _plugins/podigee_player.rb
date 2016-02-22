#  Usage: 
#  
#    {% podigee_player "title" "subtitle" "description" "cover_url" "podcast_feed_url" "mp3_url" %}
#    

require 'shellwords'

module Jekyll
  class PodigeePlayerTag < Liquid::Tag

    def initialize(tag_name, markup, tokens)
      super
      params = Shellwords.shellwords markup
      @episode = {  :title => params[0], 
                    :subtitle => params[1],
                    :description => params[2],
                    :cover_url => params[3], 
                    :podcast_feed_url => params[4], 
                    :mp3_url => params[5] 
                  }

      @episode[:id] = random_string(20)
    end

    def render(context)
      "<script>

        window.#{@episode[:id]} = {
          \"options\": {
            \"theme\": \"default\"
          },
          \"extensions\": {
            \"ChapterMarks\": {
              \"showOnStart\": false,
              \"disabled\": true
            },
            \"EpisodeInfo\": {
              \"showOnStart\": false
            },
            \"Playlist\": {
              \"showOnStart\": false,
              \"disabled\": true
            },
            \"Transcript\": {
              \"showOnStart\": false,
              \"disabled\": true
            }
          },
          \"podcast\": {
            \"feed\": \"#{@episode[:podcast_feed_url]}\",
          },
          \"episode\": {
            \"media\": {
              \"mp3\": \"#{@episode[:mp3_url]}\"
            },
            \"cover_url\": \"#{@episode[:cover_url]}\",
            \"title\": \"#{@episode[:title]}\",
            \"subtitle\": \"#{@episode[:subtitle]}\",
            \"description\": \"#{@episode[:description]}\"
          }
        }

      </script><script class=\"podigee-podcast-player\" src=\"https://cdn.podigee.com/podcast-player/javascripts/podigee-podcast-player.js\" data-configuration=\"#{@episode[:id]}\"></script>"
    end

    private
      def random_string(length = 8)
        return ('a'..'z').to_a.shuffle[0,length].join
      end

  end

end

Liquid::Template.register_tag('podigee_player', Jekyll::PodigeePlayerTag)
namespace :tags do
  task :generate do
    puts 'Generating tags...'
    require 'rubygems'
    require 'jekyll'
    include Jekyll::Filters

    options = Jekyll.configuration({})
    site = Jekyll::Site.new(options)
    site.read_posts('')

    cloud_tags = []
    tag_cloud_html = "<h2 id='tag_cloud'>Tag Cloud:</h2><p id='tag_cloud'>"
    body_html = ''
    layout_html =<<-HTML
---
layout: blog
title: Tags
---
    HTML
    
    body_html << "<h2>Tags</h2>"

    # iterate over tags & related posts
    site.tags.sort.each do |tag, posts|
      cloud_tags << tag
      body_html << <<-HTML
      <h3 id="#{tag}">#{tag}:</h3>
      <ul class="posts">
      HTML

      posts.each do |post|
        post_data = post.to_liquid
        body_html << <<-HTML
          <li class="post">
            <p class="title"><a href="#{post.url}">#{post_data['title']}</a></p>
            <p class="date">#{date_to_string post.date}</p>
          </li>
        HTML
      end
      body_html << '</ul>'
    end

    # create tag cloud
    cloud_tags.each_with_index do |tag, index|
      tag_cloud_html << "<span class='tag #{tag}'><a href='##{tag}'>#{tag}</a></span>"
      tag_cloud_html << ", " unless cloud_tags.length == index+1
    end
    # end tag cloud
    tag_cloud_html << "</p>"
    
    # prepend tag cloud to page html
    page_html = layout_html + tag_cloud_html + body_html

    File.open('tags.html', 'w+') do |file|
      file.puts page_html
    end

    puts 'Done.'
  end
end

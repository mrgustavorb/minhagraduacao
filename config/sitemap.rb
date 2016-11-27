require 'rubygems'
require 'sitemap_generator'

SitemapGenerator.verbose = true
SitemapGenerator::Sitemap.default_host = 'http://www.minhagraduacao.com'
SitemapGenerator::Sitemap.create do

   add '/contato',    :changefreq => 'monthly', :priority => 0.6
  # add '/termo-de-uso',    :changefreq => 'monthly'
  # add '/blog',    :changefreq => 'weekly', :priority => 0.7
  # add '/todas-as-opinioes', :changefreq => 'weekly', :priority => 0.7

  # Post.find_each do |post|
  #   add post_show_path(post.url_friendly), lastmod: post.updated_at
  # end

  Graduation.find_each do |graduation| 
    add graduation_about_path(graduation.url_friendly), lastmod: Time.now, :priority => 1
  end

  Institution.find_each do |institution| 
    add institution_show_perfil_path(institution.url_friendly, institution.id), lastmod: Time.now, :priority => 0.9
    institution.graduations.to_a.uniq.each do |graduation| 
      add institution_show_path(institution.url_friendly, graduation.url_friendly, institution.id), lastmod: Time.now, :priority => 0.8
    end
  end

end

SitemapGenerator::Sitemap.ping_search_engines
module Chalk
  # Turns a tag slug like "game-design" into a display name "Game Design".
  def self.titleize(slug)
    slug.to_s.split(/[-_]/).map { |w| w.empty? ? w : w[0].upcase + w[1..-1] }.join(' ')
  end

  module TitleizeTagFilter
    def titleize_tag(slug)
      Chalk.titleize(slug)
    end
  end

  # Generates /tag/<slug>/ archive pages for every tag actually used in
  # _posts front matter, so tags never need a matching file in _my_tags.
  class TagPageGenerator < Jekyll::Generator
    safe true

    def generate(site)
      site.tags.each_key do |tag|
        site.pages << TagPage.new(site, tag)
      end
    end
  end

  class TagPage < Jekyll::Page
    def initialize(site, tag)
      @site = site
      @base = site.source
      @dir  = File.join('tag', tag)
      @name = 'index.html'

      process(@name)

      self.data = {
        'layout'  => 'articles_by_tag',
        'slug'    => tag,
        'name'    => Chalk.titleize(tag),
        'title'   => "#{Chalk.titleize(tag)} - Posts",
        'sitemap' => false,
      }
    end
  end
end

Liquid::Template.register_filter(Chalk::TitleizeTagFilter)

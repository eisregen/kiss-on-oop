#!/usr/bin/ruby


module CMS


    require 'cms/Structure/Structure'
    require 'cms/Compose/Compose'

    STRUCT = CMS::Structure::Structure.new.load
    PAGES  = CMS::Pages::Pages.new.load
    BLOCKS = CMS::Blocks::Blocks.new.load

    puts Compose::page_html 'home'



end

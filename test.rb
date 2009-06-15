#!/usr/bin/ruby


module CMS


    require 'cms/Core/Page'
    require 'cms/Core/BlockModules/TextBlock'
    require 'cms/Core/Block'

 #   pg = Core::Page.new 'page1'

 #   pg.blocks=['block1','block2']

#    pg.pagetitle = 'the title'

#    pg.dump
    
#    pg.load

 #   puts pg.html
    

#    block = CMS::BlockModules::TextBlock.new 'block1'
    block = CMS::Core::Block.new 'block1'
    block.load
    puts block.html




end

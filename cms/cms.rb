#!/usr/bin/ruby

module CMS

    # for now, this is only a playground for the developers :)

    require 'cms/Utils/Utils'
    require 'cms/Core/Block'


    block = Core::Block.new('name2','title','type')
    block.blocksrc="just a test\n maan"
#    block.load
    block.dump

end

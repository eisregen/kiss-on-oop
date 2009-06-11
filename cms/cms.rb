#!/usr/bin/ruby

module CMS

    # for now, this is only a playground for the developers :)

    require 'cms/Utils/Utils'
    require 'cms/Core/Block'
    require 'cms/Config/Config'


    block = Core::Block.new('name','da title','atype')
    block.blocksrc="just a test\n maan"
#    block.load
    block.dump

    cfg = Config::Configuration.new 'config.yaml',nil

    puts cfg.system.path['html']


end

#!/usr/bin/ruby

module CMS

    # for now, this is only a playground for the developers :)

    require 'cms/Utils/Utils'
    require 'cms/Core/Block'
    require 'cms/Config/Config'

    require 'cms/Userspace/Block'

#    block = Core::Block.new('name')
#    block.blocksrc="just a test\n maan"
#    block.load
#    block.dump

#    puts block.blocksrc

#    cfg = Config::Configuration.new 'config.yaml'

#    puts cfg.system.path['html']

#    puts Userspace::MKBLOCK_DESCR
   
#    string = 'mkblock'

#    var = eval('Userspace::'+string.upcase+'_DESCR')

#    puts var
    #

    if not ARGV[0]
        puts 'type \''+__FILE__+'\' help for usage information'
    elsif ARGV[0]=='help'
        if not ARGV[1]
            puts 'Possible commands are:'
            (Userspace.methods false).reject{|m| m=~ /.*\_helper$/}.reject{|m| m=~ /.*\_description$/}.each do |m|
                print '\''+m+'\' '
                Userspace.send((m+'_description').to_sym)
            end
        elsif Userspace.methods.reject{|m| m=~ /.*\_helper$/}.include? ARGV[1]
            if not ARGV[2]
                Userspace.send((ARGV[1]+'_helper').to_sym,nil)
            else
                Userspace.send((ARGV[1]+'_helper').to_sym,ARGV[2])
            end
        else
            puts 'help not found'
        end
    else
        if Userspace.methods.reject{|m| m=~ /.*\_helper$/}.include? ARGV[0]
            if not ARGV[1]
                Userspace.send(ARGV[0],nil)
            else
                Userspace.send(ARGV[0],ARGV[1..-1])
            end
        else
            puts 'command not found'
        end
    end


end

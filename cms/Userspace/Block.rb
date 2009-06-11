module CMS
#
# Userspace methods around class Block
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#   This file holds all methods, which should be accessible from the user and
#   are Block-related.
#
#   It also should work as a kind of template for all the follownig
#   userspace-mthods
#
#   This are:
#       mkblock 'blockname', 'blocktitle', 'blocktype'
#       
#

module Userspace

    require File.join('cms','Config','Settings')
    MODULE_PATH = 'Userspace'

    def Userspace.mkblock (args)
        if args.length < 3
            puts 'not enough arguments'
            return
        end
        blockname = args[0]
        blocktitle = args[1]
        blocktype = args[2]
        if File.exist? File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],blocktype+'.rb') 
            puts 'type\'s ok'
        end
    end

    def Userspace.mkblock_description
        puts 'is used for creation of blocks'
    end

    def Userspace.mkblock_helper (arg)
       if not arg
           puts 'mkblock can be used to create an new content block'
           puts 'The following arguments should be given:'
           puts '  [blockname],[blocktitle],[blocktype]'
       else
           puts 'help accepts no additional arguments'
       end
    end


end


end

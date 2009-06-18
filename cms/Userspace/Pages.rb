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
#       mkpage 'blockname', 'blocktitle', 'blocktype'
#       
#

module CMS
  module Userspace

    require File.join('cms','Config','Settings')
    require File.join('cms','Utils','Utils')
    require File.join('cms','Blocks','Blocks')
    require File.join('cms','Pages','Pages')

    MODULE_PATH = 'Userspace'

    PAGES = Pages::Pages.new.load

    # {{{ mkpage
    def Userspace.mkpage (args)
      raise 'Not enough arguments' if !args || args.size < 3

      name = args[0]
      title = args[1]
      blocknames = args.drop 2

      raise 'Invalid Pagename.'     unless Utils.valid? name
      raise 'Page already exists.'  if     PAGES.exist? name #File.exist? (File.join('cms','Pages','Files',pagename+'.blk'))

      blocks = Array.new
      blocknames.each do |b|
        tmp = CMS::Core::Block.new(b)
        raise 'Block '+b+' does not exist' unless tmp.exist?
        tmp.load
        blocks << tmp
      end

      PAGES.add_page(name, title, blocks).dump

      #blocks.each do |b|
        #puts b.html
      #end
    end # }}}

    #TODO

    # {{{ mkpage description
    def Userspace.mkpage_description
      puts 'is used to create pages'
    end # }}}
    # {{{ mkpage help
    def Userspace.mkpage_help (arg)
      if not arg
        puts 'mkpage can be used to create a new page'
        puts 'The following arguments should be given:'
        puts '  [pagename] [pagetitle] [list] [of] [blocks]'
      else
        puts 'help accepts no additional arguments'
      end
    end # }}}

    ## everything beyond THIS Line is copypasta for Userspace/Block.rb -- don't mind   

    # {{{ rmpage
    def Userspace.rmpage args
      if !args || args.size < 1
        raise 'Not enough arguments'
      end
      blockname = args[0]

      if not Utils.valid? blockname
        raise 'Invalid blockname'
      elsif not File.exist? fqn = File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['blocks'],blockname+'.'+Config::SYSTEM.extensions['block'])
        raise 'Block doesn\'t exist'
      else
        block = Core::Block.new blockname
        block.load
        block.delete
      end
    end # }}}
    # {{{ rmpage description
    def Userspace.rmpage_description
      puts 'is used for deletion of blocks'
    end # }}}
    # {{{ rmpage help
    def Userspace.rmpage_help (arg)
      if not arg
        puts 'rmpage can be used to delete a given block'
        puts 'The following argument should be given:'
        puts '  [blockname]'
      else
        puts 'help accepts no additional arguments'
      end
    end # }}}


    # {{{ lspage
    def Userspace.lspage args
      if !args || args.size < 1
        block_path = File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['blocks'])

        Dir.open(block_path).select { |d| d =~ /.*\.#{Config::SYSTEM.extensions['block']}$/ }.each do |b|
          puts b[0..-1*(Config::SYSTEM.extensions['block'].length+2)]
        end

        return
      end

      blockname = args[0]

      if not Utils.valid? blockname
        raise 'Invalid blockname'
      elsif not File.exist? File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['blocks'],blockname+'.'+Config::SYSTEM.extensions['block'])
        raise 'Block doesn\'t exist'
      else
        block = Core::Block.new blockname
        block.load
        puts 'blockname:   '+block.blockname
        puts 'blocktitle:  '+block.blocktitle
        puts 'blocktype:   '+block.blocktype
      end
    end # }}}
    # {{{ lspage description
    def Userspace.lspage_description
      puts 'is used for listing of blocks'
    end # }}}
    # {{{ lspage help
    def Userspace.lspage_help (arg)
      if not arg
        puts 'lspage can be used to show all blocks.'
        puts 'Besides it can be used to view the details of a block.'
        puts 'For that, the following argument should be given:'
        puts '  [blockname]'
      else
        puts 'help accepts no additional arguments'
      end
    end # }}}


    # {{{ chpage
    def Userspace.chpage args
      if !args || args.length < 2
        raise 'Not enough arguments'
      end

      if not Utils.valid? args[0]
        raise 'Invalid blockname'
        return
      end

      blockname = args[0]
      action = args[1]

      if action=='content'
        system Config::SYSTEM.editor+' '+File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['blocks'],blockname+'.'+Config::SYSTEM.extensions['block'])
      else
        if not val=args[2]
          raise 'Not enough arguments'
        else
          block = Core::Block.new blockname
          block.load
          case action
          when 'name'
            if Util.valid? val
              block.blockname = val
            else
              raise 'Invalid new blockname'
            end
          when 'title'
            puts block.blocktitle
            block.blocktitle = val
            puts block.blocktitle
          when 'type'
            if File.exist? File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],val+'.rb')
              block.blocktype = val
            else
              raise 'Unknown blocktype'
            end
          else
            raise 'Invalid action'
          end
          block.dump
        end
      end

    end # }}}
    # {{{ chpage description
    def Userspace.chpage_description
      puts 'is used to change attributes of blocks'
    end # }}}
    # {{{ chpage help
    def Userspace.chpage_help (arg)
      if not arg
        puts 'chpage can be used to change the block-attributes.'
        puts 'For changing the content of a block, type: '
        puts '  [blockname] [content]'
        puts 'For modification of one of its arguments, type:'
        puts '  [blockname] [name|title|type] [value]'
      else
        puts 'help accepts no additional arguments'
      end
    end # }}}


  end


end

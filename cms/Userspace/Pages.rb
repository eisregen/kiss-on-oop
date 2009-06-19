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
        raise 'Block '+b+' does not exist' unless BLOCKS.exist? b
        blocks << b
      end

      PAGES.add_page(name, title, blocks).dump

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


    # {{{ rmpage
    def Userspace.rmpage args
      raise 'Not enough arguments' if !args || args.size < 1

      name = args[0]
      
      raise 'Invalid pagename'   unless Utils.valid? name
      raise 'Page doesn\'t exist' unless PAGES.exist? name

      PAGES.rm_page(name).dump

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
      if (not args.nil?) && args.size == 2
        opt = args[0]
        var = args[1]
      end

      PAGES.get_names.each do |name|
        title = PAGES.get_title name
        blocks = PAGES.get_blocks name

        case opt
        when '-n' then next unless name  == var
        when '-T' then next unless type  == var
        end

        puts "Page:    " + name
        puts "Title:   " + title
        blocks.each do |block|
          if block == blocks.first
            puts "Blocks   - " + block
          else
            puts "         - " + block
          end
        end
        puts "\n\n"
      end

    end # }}}
    # {{{ lspage description
    def Userspace.lspage_description
      puts 'Show all pages.'
    end # }}}
    # {{{ lspage help
    def Userspace.lspage_help (arg)
      puts 'Show all blocks.'
      puts 'Options:  [-n <name> | -T <title>]'
    end # }}}


    # {{{ chpage
    def Userspace.chpage args
      raise 'Not enough arguments' if !args || args.length < 3

      name = args[0]
      opt = args[1]
      val = args[2]

      raise 'Invalid pagename'   unless Utils.valid? name
      raise 'Page doesn\'t exist' unless PAGES.exist? name

      case opt
      when '-n' then PAGES.set_name(name,val).dump
      when '-T' then PAGES.set_title(name,val).dump
      else raise 'Wrong argument'
      end
    end # }}}
    # {{{ chpage description
    def Userspace.chpage_description
      puts 'Modificates attributes of a page.'
    end # }}}
    # {{{ chpage help
    def Userspace.chpage_help (arg)
      puts 'Modificates attributes of a page.:'
      puts 'Options: [blockname] [-n <name> | -T <title>]'
    end # }}}


  end


end

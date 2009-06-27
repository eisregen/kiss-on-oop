#
# Userspace methods around the Structure class
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de | irc: #kiss on xinutec.org
#
#   This file holds all methods, which should be accessible from the user and
#   are related with the Structure:
#
#       mkstruct <name> [<parent>] [-r]
#       rmstruct <name> [-f]
#       mvstrcut <name> count
#       lsstruct
#       
#

module CMS
  module Userspace

    require File.join('cms','Config','Settings')
    require File.join('cms','Structure','Structure')
    require File.join('cms','Utils','Utils')

    # {{{ mkstruct
    def Userspace.mkstruct (args)

      if not args || args.size < 1
        raise 'Not enough arguments.'
      end

      if args.size >= 2
        replace = (args.include? '-f')
        args.delete('-f')
        parent = args[0]
        name = args.drop 1
      else
        name = args[0]
      end

      name.each do |name|
        unless STRUCT.is_elem? name
          STRUCT.add_page(name, parent)
        else
          STRUCT.rm_page(name) if replace
          STRUCT.add_page(name, parent)
        end

      end

      STRUCT.dump

    end # }}}
    # {{{ mkstruct description
    def Userspace.mkstruct_description
      puts 'add a page to the current structure'
    end # }}}
    # {{{ mkstruct help
    def Userspace.mkstruct_help (arg)
      puts 'mkstruct adds a page to the current structure.'
      puts 'Use the -f option to set a new parent of an existing page (top if none given).'
      puts 'Options:  [-f] [<parent>] <names...>'
    end # }}}

    # {{{ mvstruct
    def Userspace.mvstruct (args)

      if not args || args.size < 2
        raise 'Not enough arguments.'
      end
      name = args[0]
      if (count = args[1].to_i) <= 0
        raise "Null, negative or no number given: #{count}"
      end

      STRUCT.mv_page(name, count)

      STRUCT.dump

    end # }}}
    # {{{ mvstruct description
    def Userspace.mvstruct_description
      puts 'Move a page in the current structure'
    end # }}}
    # {{{ mvstruct help
    def Userspace.mvstruct_help (arg)
      puts 'mvstruct moves a page in the current structure'
      puts 'Options:  <name> <count>'
    end # }}}

    # {{{ rmstruct
    def Userspace.rmstruct args
      if !args || args.size < 1
        raise 'Not enough arguments'
      end

      force = args.include? '-f'
      args.delete '-f'

      args.each do |name|
        # force rm, even if page has children
        if STRUCT.is_parent?(name) && force
          children = STRUCT.get_children(name)
          puts "Removing children:\n#{Utils.unlines children}"

          STRUCT.rm_page(name)

        elsif STRUCT.is_parent?(name)
          # Error: No force flag, but name has children
          children = STRUCT.get_children(name)
          raise "#{name} has children. Use \"rmstruct <name> -f\" to force action.\n\nChildren are:\n#{Utils.unlines children}"

        else
          # No error, remove single page
          puts "Removing: #{name} (no children found)"
          STRUCT.rm_page(name)

        end

      end

      STRUCT.dump

    end # }}}
    # {{{ rmstruct description
    def Userspace.rmstruct_description
      puts 'is used to remove pages from the structure'
    end # }}}
    # {{{ rmstruct help
    def Userspace.rmstruct_help (arg)
      puts 'rmstruct is used to remove a given page from the structure'
      puts 'Options:  <name> [-f]'
    end # }}}

    # {{{ lsstruct
    def Userspace.lsstruct (args)

      if args.nil? || args.length < 1
        parent = 'top'
      else
        parent = args[0]
      end
      puts Utils.tree_struct(parent)

    end # }}}
    # {{{ lsstruct description
    def Userspace.lsstruct_description
      puts 'lists the structure of a given page (everything if no arguments)'
    end # }}}
    # {{{ lsstruct help
    def Userspace.lsstruct_help (arg)
      puts 'lsstruct lists the structure of a given page.'
      puts 'If no page is given, lsstruct lists all elements.'
      puts 'Options:  [name]'
    end # }}}

  end


end

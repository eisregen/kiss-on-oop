#
# Userspace methods around the Structure class
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de | irc: #kiss on xinutec.org
#
#   This file holds all methods, which should be accessible from the user and
#   are related with the Structure:
#
#       mkstruct <name> [<parent>]
#       rmstruct <name> [-f]
#       chstruct <name> [<parent>]
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
      name = args[0]
      parent = args[1]

      (Structure::Structure.new).load.add_page(name, parent).dump

    end # }}}
    # {{{ mkstruct description
    def Userspace.mkstruct_description
      puts 'add a page to the current structure'
    end # }}}
    # {{{ mkstruct help
    def Userspace.mkstruct_help (arg)
      puts 'mkstruct adds a page to the current structure'
      puts 'Options:  <name> [<parent>]'
    end # }}}

    # {{{ rmstruct
    def Userspace.rmstruct args
      if !args || args.size < 1
        raise 'Not enough arguments'
      end
      name = args[0]
      force = args.last

      struct = Structure::Structure.new.load

      # force rm, even if page has children
      if struct.is_parent?(name) && (force == '-f')
        children = struct.get_children(name)
        puts "Removing children:\n#{Utils.unlines children}"

        result = struct.rm_page(name)

      elsif struct.is_parent?(name)
        # Error: No force flag, but name has children
        children = struct.get_children(name)
        raise "#{name} has children. Use \"rmstruct <name> -f\" to force action.\n\nChildren are:\n#{unlines children}"

      else
        # No error, remove single page
        puts "Removing: #{name} (no children found)"
        result = struct.rm_page(name)

      end

      result.dump

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
      puts (Utils.get_tree(parent))

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

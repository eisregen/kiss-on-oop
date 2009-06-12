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

        # {{{ mkstruct
        def Userspace.mkstruct (args)

            if not args || args.size < 1
                raise 'Not enough arguments.'
            end
            name = args[0]
            parent = args[1]

            (Structure::Structure.new).load.addPage(name, parent).dump

        end # }}}
        # {{{ mkstruct description
        def Userspace.mkstruct_description
            puts 'add a page to the current structure'
        end # }}}
        # {{{ mkstruct helper
        def Userspace.mkstruct_helper (arg)
            puts 'mkstruct adds a page to the current structure'
            puts 'Options:'
            puts '    <name> [<parent>]'
        end # }}}

        # {{{ rmstruct
        def Userspace.rmstruct args
            if !args || args.size < 1
                raise 'Not enough arguments'
            end
            name = args[0]
            force = args[1]

            struct = Structure::Structure.new.load()

            if struct.hasChildren?(name) && force != '-f'
                struct.getChildren(name) { |children| raise "#{name} has children. Use \"rmstruct <name> -f\" to force action.\n\nChildren are:\n#{children}" }
            end

            struct.rmPage(name).dump()

        end # }}}
        # {{{ rmstruct description
        def Userspace.rmstruct_description
            puts 'is used to remove pages from the structure'
        end # }}}
        # {{{ rmstruct helper
        def Userspace.rmstruct_helper (arg)
            puts 'rmstruct is used to remove a given page from the structure'
            puts 'Options:'
            puts '    <name> [-f]'
        end # }}}

        # {{{ lsstruct
        def Userspace.lsstruct (args)

            if args.nil? || args.length < 1
                parent = 'top'
            else
                parent = args[0]
            end

            # unlines is an inverse operation to lines.
            def unlines
                if not (self.init.nil? && self.last.nil?)
                    result = self.init.map { |line| line + "\n" } << self.last
                    return result.flatten
                else
                    return self
                end
            end
            # Get the tree structure as an array of Strings
            def getTree (parent, struct = Structure::Structure.new.load)

                result = []
                struct.getChildren(parent).each do |child|

                    result <<= child
                    if child.hasChildren?
                        result.concat(getTree(child).map {|s| "|- " + s})
                    end

                end

                return result
            end

            puts getTree(parent).unlines

        end # }}}
        # {{{ lsblock description
        def Userspace.lsstruct_description
            puts 'lists the structure of a given page (everything if no arguments)'
        end # }}}
        # {{{ lsblock helper
        def Userspace.lsstruct_helper (arg)
            puts 'lsstruct lists the structure of a given page.'
            puts 'If no page is given, list all elements.'
            puts "\nOptions:"
            puts '    [name]'
        end # }}}

    end


end

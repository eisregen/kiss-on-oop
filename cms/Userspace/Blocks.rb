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

module CMS
  module Userspace

    require File.join('cms','Config','Settings')
    require File.join('cms','Utils','Utils')
    require File.join('cms','Blocks','Blocks')


    # {{{ mkblock
    def Userspace.mkblock (args)
      if !args || args.size < 3
        raise 'Not enough arguments.'
      end
      name = args[0]
      title = args[1]
      type = args[2]

      blockpath = File.join('cms','Blocks','Files',name+'.blk')
      typepath  = File.join('cms','Blocks','Modules',type+'.rb')

      raise "Invalid Blockname: #{name}"    unless Utils.valid? name
      raise "Block already exists: #{name}" if File.exist? blockpath
      raise "Unknown Blocktype: #{type}"    unless File.exist? typepath

      # Add and save
      BLOCKS.add_block(name, title, type).dump
    end # }}}
    # {{{ mkblock description
    def Userspace.mkblock_description
      puts 'Create a new block.'
    end # }}}
    # {{{ mkblock help
    def Userspace.mkblock_help (arg)
      puts 'mkblock can be used to create a new content block'
      puts 'The following arguments should be given:'
      puts 'Options:  <blockname> <blocktitle> <blocktype>'
    end # }}}


    # {{{ rmblock
    def Userspace.rmblock args
      if !args || args.size < 1
        raise 'Not enough arguments'
      end
      name = args[0]

      blockpath = File.join('cms','Blocks','Files',name+'.blk')

      raise "Invalid blockname: #{name}" unless Utils.valid? name
      raise "Block doesn\'t exist: #{name}" unless BLOCKS.exist? name

      BLOCKS.rm_block(name).dump

    end # }}}
    # {{{ rmblock description
    def Userspace.rmblock_description
      puts 'Remove a given block.'
    end # }}}
    # {{{ rmblock help
    def Userspace.rmblock_help (arg)
      puts 'rmblock removes a block'
      puts 'The following argument should be given:'
      puts 'Options:  <blockname>'
    end # }}}


    # {{{ lsblock
    def Userspace.lsblock args
      if (not args.nil?) && args.size == 2
        opt = args[0]
        var = args[1]
      end

      BLOCKS.get_names.each do |name|
        title = BLOCKS.get_title name
        type  = BLOCKS.get_type name

        case opt
        when '-n' then next unless name  == var
        when '-t' then next unless type  == var
        when '-T' then next unless title == var
        end

        puts "Block:   " + name
        puts "Title:   " + title
        puts "Type:    " + type + "\n\n"

      end
    end # }}}
    # {{{ lsblock description
    def Userspace.lsblock_description
      puts 'Show all blocks.'
    end # }}}
    # {{{ lsblock help
    def Userspace.lsblock_help (arg)
      puts 'Show all blocks.'
      puts 'Options:  [-n <name> | -t <type> | -T <title]'
    end # }}}


    # {{{ chblock
    def Userspace.chblock args
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
    # {{{ chblock description
    def Userspace.chblock_description
      puts 'is used to change attributes of blocks'
    end # }}}
    # {{{ chblock help
    def Userspace.chblock_help (arg)
      if not arg
        puts 'chblock can be used to change the block-attributes.'
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

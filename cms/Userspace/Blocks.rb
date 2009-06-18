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
    require File.join(Config::SYSTEM.path['root'],'Utils','Utils')
    require File.join(Config::SYSTEM.path['root'],'Core','Block')
    
   
    # {{{ mkblock
    def Userspace.mkblock (args)
        if !args || args.size < 3
            raise 'Not enough arguments.'
        end
        blockname = args[0]
        blocktitle = args[1]
        blocktype = args[2]

        if not Utils.valid? blockname
            puts 'Invalid Blockname.'

        elsif File.exist? fqn = File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['blocks'],blockname+'.'+Config::SYSTEM.extensions['block'])
            puts 'Block already exists.'

        elsif not File.exist? File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],blocktype+'.rb')
            puts 'Unknown Blocktype.'

        else
            require File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],blocktype)

            block = CMS::Core::Block.new blockname
            block.blocktitle = blocktitle
            block.setBlocktype blocktype
            
            block.dump

            system Config::SYSTEM.editor+' '+fqn

        end
    end # }}}
    # {{{ mkblock description
    def Userspace.mkblock_description
        puts 'is used to create blocks'
    end # }}}
    # {{{ mkblock help
    def Userspace.mkblock_help (arg)
       if not arg
           puts 'mkblock can be used to create a new content block'
           puts 'The following arguments should be given:'
           puts '  [blockname],[blocktitle],[blocktype]'
       else
           puts 'help accepts no additional arguments'
       end
    end # }}}

    
    # {{{ rmblock
    def Userspace.rmblock args
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
    # {{{ rmblock description
    def Userspace.rmblock_description
        puts 'is used for deletion of blocks'
    end # }}}
    # {{{ rmblock help
    def Userspace.rmblock_help (arg)
        if not arg
           puts 'rmblock can be used to delete a given block'
           puts 'The following argument should be given:'
           puts '  [blockname]'
       else
           puts 'help accepts no additional arguments'
       end
    end # }}}


    # {{{ lsblock
    def Userspace.lsblock args
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
    # {{{ lsblock description
    def Userspace.lsblock_description
        puts 'is used for listing of blocks'
    end # }}}
    # {{{ lsblock help
    def Userspace.lsblock_help (arg)
        if not arg
           puts 'lsblock can be used to show all blocks.'
           puts 'Besides it can be used to view the details of a block.'
           puts 'For that, the following argument should be given:'
           puts '  [blockname]'
       else
           puts 'help accepts no additional arguments'
       end
    end # }}}


    # {{{ lsblockmodule
    def Userspace.lsblockmodule args
        if !args || args.size < 1
            blockmod_path = File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'])

            Dir.open(blockmod_path).select { |d| d =~ /.*\.rb$/ }.each do |b|
                puts b[0..-4]
            end

            return
        end

        blockmodname = args[0]

        if not Utils.valid? blockmodname
            raise 'Invalid Blockmodulename'
        elsif not File.exist? File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],blockmodname+'.rb')
            raise 'Blockmodule doesn\'t exist'
        else
            require File.join(Config::SYSTEM.path['root'],'Core',Config::SYSTEM.path['block_modules'],blockmodname+'.rb')
            puts CMS::Core::BlockModules.const_get(blockmodname)::TITLE+' - '+CMS::Core::BlockModules.const_get(blockmodname)::DESCRIPTION
            puts '  Author: '+CMS::Core::BlockModules.const_get(blockmodname)::AUTHOR
            puts '  Add.  : '+CMS::Core::BlockModules.const_get(blockmodname)::ADDITIONAL

        end
    end # }}}
    # {{{ lsblockmodule description
    def Userspace.lsblockmodule_description
        puts 'is used for listing of Blocksmodules'
    end # }}}
    # {{{ lsblockmodule help
    def Userspace.lsblockmodule_help (arg)
        if not arg
           puts 'lsblockmodule can be used to show all Blockmodules.'
           puts 'Besides it can be used to view the details of a Blockmodule.'
           puts 'For that, the following argument should be given:'
           puts '  [blockmodulename]'
       else
           puts 'help accepts no additional arguments'
       end
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

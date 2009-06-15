#
# class Block
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#
#   'Block' representates a block. Through the different methods it works as an
#   layer between the several files per block and the application itself.
#
#   also it is planned to use different types of Blocks which can derive from
#   Block. This would cause a great modularity.
#
#   TODO:   all configuration parameters are listed below. they need to be
#           substituted through the config class
#

module CMS
    module Core

        require File.join('cms','Config','Settings')

        require File.join(Config::SYSTEM.path['root'],'Utils','Utils')

        BLOCK_FILE_PATH = File.join(Config::SYSTEM.path['root'],Config::SYSTEM.path['module'],Config::SYSTEM.path['blocks'],Config::SYSTEM.path['block_file'])


        # ERROR_ARG_NOT_GIVEN = ' must be given'
        # ERROR_ARG_INVALID = ' produced the foollowing error: '
        # ERROR_EXISTS = ' allready exists'
        # ERROR_NOT_EXISTENT = ' don\'t exists'


        BLOCK_MODULE_PATH = File.join(Config::SYSTEM.path['root'],Config::SYSTEM.path['module'],Config::SYSTEM.path['block_modules'])

        #    Dir.open(BLOCK_MODULE_PATH).select { |d| d =~ /.*\.rb$/ }.each do |f|
        #        require File.join(BLOCK_MODULE_PATH,f) 
        #    end



        # {{{ Block definition
        class Block

            attr_accessor :blocksrc
            attr_accessor :blocktitle
            attr_accessor :blockname

            # the blockname format is not specified. It can be with ending or without
            #   it throws an ArgumentError whith a message whats went wrong
            def initialize (blockname) # {{{

                # if the blockname is with ending, it'll be cutted
                @blockfqn = File.join(Config::SYSTEM.path['root'],Config::SYSTEM.path['module'],Config::SYSTEM.path['blocks'])
                if blockname =~ /.*\.#{Config::SYSTEM.extensions['block']}$/
                    @blockfqn = File.join(@blockfqn,blockname)
                    blockname = blockname[0..-1*(Config::SYSTEM.extensions['block'].length+2)]
                else
                    @blockfqn = File.join(@blockfqn,blockname+'.'+Config::SYSTEM.extensions['block'])
                end

                @blockname = blockname
                
                puts 'blockname: '+@blockname+', FQN: '+@blockfqn

            end # }}}

            def setBlocktype type
                @blocktype = CMS::Core::BlockModules.const_get(type).new(@blockname,@blocktitle,@blocksrc)
            end

            def getBlocktype
                return @blocktype.class.to_s
            end

            def dump # {{{
                if @blocksrc
                    File.open(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT) do |f|
                        @blocksrc.each {|l| f << l}
                    end
                else
                    FileUtils.touch @blockfqn
                end

                if not File.exist? BLOCK_FILE_PATH
                    # if the yaml file doesnt exist, create an empty list,
                    blockfile = []
                else
                    # otherwise load the file
                    blockfile = YAML::load_file BLOCK_FILE_PATH
                end

                # adds the metainformation to the yaml-file 
                if blockfile.include? @blockname
                    i = blockfile.index @blockname
                end
                blockfile += [@blockname,[@blocktitle,self.getBlocktype]]

                #TODO: file modifier oO
                File.open(BLOCK_FILE_PATH, 'w') do |out|
                    YAML::dump(blockfile, out )
                end

                @blocktype.afterDump

            end # }}}

            # if the block was already existent and should only be changed, instead of a
            # first dump, a load gets the blocksource from the file
            def load # {{{
                @blocksrc = ''
                IO.readlines(@blockfqn).each do |l|
                    @blocksrc += l
                end

                # get metainformation
                blockfile = YAML::load_file BLOCK_FILE_PATH
                if index=blockfile.index(@blockname)
                    @blocktitle = blockfile[index+1][0]
#                    @blocktype = CMS::Core::BlockModules.const_get(blockfile[index+1][1]).new(@blockname,@blocktitle,@blocksrc)
                    self.setBlocktype blockfile[index+1][1].split('::').last
                end
                puts 'blocktitle: '+@blocktitle+', type: '+@blocktype.class.to_s
                puts 'blocksrc: '
                puts @blocksrc

                @blocktype.afterLoad
            end # }}}


            # removes all the crap.. THE BLOCK WILL BE ERASED! :P
            def delete # {{{
                File.delete @blockfqn

                @blocktype.beforeDeletion

                blockfile = YAML::load_file BLOCK_FILE_PATH
                blockfile -= [@blockname,[@blocktitle,@blocktype]]

                File.open(BLOCK_FILE_PATH, 'w') do |out|
                    YAML.dump(blockfile, out )
                end

            end # }}}

            def html
                @blocktype.html
            end

        end # }}}



    end
end

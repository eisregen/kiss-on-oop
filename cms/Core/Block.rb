module CMS
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

module Core

    require File.join('cms','Config','Settings')
#    $CFG = Config::Config::ration.new 'config.yaml',nil

    $MODULE_PATH = 'Core'
    $BLOCK_FILE_PATH = File.join(Config::system.path['root'],$MODULE_PATH,Config::system.path['blocks'],Config::system.path['block_file'])


    $ERROR_ARG_NOT_GIVEN = ' must be given'
    $ERROR_ARG_INVALID = ' produced the foollowing error: '
    $ERROR_EXISTS = ' allready exists'
    $ERROR_NOT_EXISTENT = ' don\'t exists'


    require File.join(Config::system.path['root'],'Utils','Utils')


    # {{{ Block definition

    class Block

        attr_accessor :blocksrc

        # the blockname format is not specified. It can be with ending or without
        #   it throws an ArgumentError whith a message whats went wrong
        def initialize (blockname,blocktitle,type) # {{{
            
            if not Utils.valid? blockname
                raise ArgumentError,blockname+$ERROR_ARG_INVALID+'not alpanumeric'
#            elsif not Object.const_defined? type
#                raise ArgumentError,type+$ERROR_NOT_EXISTENT
            else

                # if the blockname is with ending, it'll be cutted
                @blockfqn = File.join(Config::system.path['root'],$MODULE_PATH,Config::system.path['blocks'])
                if blockname =~ /.*\.#{Config::system.extensions['block']}$/
                    @blockfqn = File.join(@blockfqn,blockname)
                    blockname = blockname[0..-1*(Config::system.extensions['block'].length+2)]
                else
                    @blockfqn = File.join(@blockfqn,blockname+'.'+Config::system.extensions['block'])
                end
        
                @blockname = blockname
                @blocktitle = blocktitle
                @type = type            # TODO: perhaps, this metainformation is given by the ruby interpreter
            end

        end # }}}

        def dump # {{{
            if @blocksrc
                File.open(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT) do |f|
                @blocksrc.each {|l| f << l}
                end
            else
                FileUtils.touch @blockfqn
            end

            if not File.exist? $BLOCK_FILE_PATH
                # if the yaml file doesnt exist, create an empty list,
                blockfile = []
            else
                # otherwise load the file
                blockfile = YAML::load_file $BLOCK_FILE_PATH
            end

            # adds the metainformation to the yaml-file TODO: file modifier oO
            blockfile += [@blockname,[@blocktitle,@type]]
            File.open($BLOCK_FILE_PATH, 'w') do |out|
                YAML.dump(blockfile, out )
            end

        end # }}}

        # if the block was already existent and should only be changed, instead of a
        # first dump, a load gets the blocksource from the file
        def load # {{{
            @blocksrc = ''
            File.open(@blockfqn,File::RDONLY|File::TRUNC|File::CREAT) do |f|
                f.each {|l| @blocksrc.puts l}
            end

            # get metainformation
            blockfile = YAML::load_file $BLOCK_FILE_PATH
            if index=blockfile.index(@blockname)
                @blocktitle = blockfile[index+1][0]
                @blocktype = blockfile[index+1][1]
            end

        end # }}}

        # this method will be called from the composer of the pages.
        # The different blockmodules *MUST* implement this method.
        #
        # *N* Not needed
        #
        #def html # {{{
        #end # }}}

        # returns a list of all important information about the derived type of
        # content-block. This could be useful for a block-type menu.
        def information # {{{
            [@author,@title,@description,@additional]
        end # }}}

        # removes all the crap.. THE BLOCK WILL BE ERASED! :P
        # TODO: implement it..
        def delete # {{{
        end # }}}

    end # }}}



end
end

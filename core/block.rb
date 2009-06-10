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


$ROOT_PATH = 'core'
$BLOCK_PATH = 'blockfiles'
$BLOCK_MODULE_PATH = 'blockmodules'
$BLOCK_POSTFIX = 'blk'
$BLOCK_FILE = 'blocks.yaml'
$BLOCK_FILE_PATH = File.join($ROOT_PATH,$BLOCK_PATH,$BLOCK_FILE)
$ERROR_ARG_NOT_GIVEN = ' must be given'
$ERROR_ARG_INVALID = ' produced the foollowing error: '
$ERROR_EXISTS = ' allready exists'
$ERROR_NOT_EXISTENT = ' don\'t exists'


require 'core/utilities'


class Block # {{{

    # the blockname format is not specified. It can be with ending or without
    # In addition, arguments are *NOT* checked against validation. This is a
    # Task for the calling function. The Topic is:
    # Crap in -> Crap out  ;)
    def initialize (blockname,blocktitle) # {{{
        # if the blockname with ending, it'll be cutted
        if blockname =~ /.*\.#{$BLOCK_POSTFIX}$/
            @blockfqn = File.join($ROOT_PATH,$BLOCK_PATH,blockname)
            blockname = blockname[0..-1*($BLOCK_POSTFIX.length+2)]
        else
            @blockfqn = File.join($ROOT_PATH,$BLOCK_PATH,blockname+'.'+$BLOCK_POSTFIX)
        end
        
        @blockname = blockname
        @blocktitle = blocktitle
    end # }}}

    def dump # {{{
        if @blocksrc
            File.open(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT) do |f|
              @blocksrc.each {|l| f << l}
            end
        else
            FileUtils.touch @blockfqn
        end
    end # }}}

    # if the block was already existent and should only be changed, instead of a
    # first dump, a load gets the blocksource from the file
    def load # {{{
        @blocksrc = ''
        File.open(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT) do |f|
          f.each {|l| @blocksrc.puts l}
        end
    end # }}}

    # this method will be called from the composer of the pages.
    # The different blockmodules *MUST* implement this method.
    def html # {{{
    end # }}}

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

# get all blockmodules 
#  perhaps TODO: forward declaration of class, so this requires can go back in the
#  head of this file
Dir.new(File.join($ROOT_PATH,$BLOCK_MODULE_PATH)).entries.select {|f| f =~ /.*\.rb$/ }.each {|f| require File.join($ROOT_PATH,$BLOCK_MODULE_PATH,f) }


# returns a list with instances of all blocks - this function is not
# designated for production, just a development helper
def getBlocks # {{{

    blocks = []
    Dir.new File.join($ROOT_PATH,$BLOCK_PATH).entries.reverse.select {|d| d =~ /.*\.#{$BLOCK_POSTFIX}$/ }.each {|d| blocks << Block.new(d)}
    blocks

end # }}}


# creates a block
def mkBlock (blockname,blocktitle,type) # {{{
    if not Utils.validate blockname
        puts blockname+$ERROR_ARG_INVALID+'not alpanumeric'
    elsif File.exist? File.join($ROOT_PATH,$BLOCK_PATH,blockname+'.'+$BLOCK_POSTFIX)
        puts blockname+$ERROR_EXISTS
#    elsif not File.exist? File.join($ROOT_PATH,$BLOCK_MODULE_PATH,type+'.rb')
#        puts type+$ERROR_NOT_EXISTENT
    elsif not Object.const_defined? type
        puts type+$ERROR_NOT_EXISTENT
    else
        block = Kernel.const_get(type).new(blockname,blocktitle)

        if not File.exist? $BLOCK_FILE_PATH
            blockfile = []
        else
            blockfile = YAML::load_file $BLOCK_FILE_PATH
        end
        puts blockfile
        blockfile += [blockname,[blocktitle,type]]
        File.open($BLOCK_FILE_PATH, 'w') do |out|
            YAML.dump(blockfile, out )
        end

        block.dump

    end

#    config = YAML::load File.open(filepath)
end # }}}



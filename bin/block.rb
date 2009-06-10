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


$BLOCK_PATH = 'blocks'
$BLOCK_POSTFIX = 'blk'


require 'bin/utilities'


class Block # {{{

    # the blockname format is not specified. It can be with ending or without
    def initialize (blockname) # {{{
        # if the blockname with ending, it'll be cutted
        if blockname =~ /.*\.#{$BLOCK_POSTFIX}$/
            @blockfqn = File.join($BLOCK_PATH,blockname)
            blockname = blockname[0..-1*($BLOCK_POSTFIX.length+2)]
        else
            @blockfqn = File.join($BLOCK_PATH,blockname+'.'+$BLOCK_POSTFIX)
        end
        
        if Utils.validate blockname
            @blockname = blockname
            @blocksrc = "blablub\nundsonstso"
        else
            raise ArgumentError, 'blockname invalid'
        end
    end # }}}

    def dump # {{{
        File.open(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT) do |f|
          puts 'woot'
          @blocksrc.each {|l| f << l}
        end

    end # }}}

    def load # {{{

    end # }}}

    def html # {{{
    end # }}}

    def information # {{{
        [@author,@description,@additional]
    end # }}}

end # }}}

# temporary testclass for some test
class TextBlock < Block
    def initialize 
        @author = 'Jakob Holderbaum'
        @description = 'aaaw, nothin special @ all'
        @additional = ''
    end
end


# returns a list with instances of all blocks
def getBlocks # {{{

    blocks = []
    Dir.new($BLOCK_PATH).entries.reverse.select {|d| d =~ /.*\.#{$BLOCK_POSTFIX}$/ }.each {|d| blocks << Block.new(d)}
    blocks

end # }}}



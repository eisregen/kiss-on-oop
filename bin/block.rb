#
# class Block
#
#   'Block' representates a block. Through the different methods it works as an
#   layer between the several files per block and the application itself.
#
#   also it is planned to use different types of Blocks which can derive from
#   Block. This would cause a great modularity.
#

# TODO: all configuration parameters are listed below. they need to be
# substituted through the config class
#  autocmd FileType ruby               map <C-f> :!ruby %<CR>
#  autocmd FileType ruby               map <C-g> :!ruby -c%<CR>


$BLOCK_PATH = 'blocks'
$BLOCK_POSTFIX = 'blk'


require 'bin/utilities'


class Block # {{{

    # the blockname format is not specified. It can be with ending or without
    def initialize (blockname) # {{{
        # if the blockname with ending, it'll be cutted
        if blockname =~ /.*\.#{$BLOCK_POSTFIX}$/
            blockname = blockname[0..-1*($BLOCK_POSTFIX.length+2)]
        end
        
        if Utils.validate blockname
            @blockname = blockname
            @blockfqn = File.join($BLOCK_PATH,blockname,$BLOCK_POSTFIX)
            @blocksrc = "blablub\nundsonstso"
        else
            raise ArgumentError, 'blockname invalid'
        end
    end # }}}

    def dump # {{{
        dumpfile = File.new(@blockfqn,File::WRONLY|File::TRUNC|File::CREAT)
        puts 'woot'
        @blocksrc.each {|l| puts l}
    end # }}}

    def load # {{{

    end # }}}

    def html # {{{
    end # }}}


end # }}}


# returns a list with instances of all blocks
def getBlocks # {{{

    blocks = Array.new
    Dir.new($BLOCK_PATH).entries.reverse.select {|d| d =~ /.*\.#{$BLOCK_POSTFIX}$/ }.each {|d| blocks += [Block.new d]}

end # }}}



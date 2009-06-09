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


require 'utilities'

Utils.validate "alpanum"

class Block # {{{

    def initialize (blockname) # {{{
        if validate blockname
            @blockname = blockname
        else
            raise ArgumentError, 'blockname invalid'
        end
    end # }}}

    def dump # {{{
        
    end # }}}

    def load # {{{
    end # }}}

    def html # {{{
    end # }}}


end # }}}


# returns a list with instances of all blocks
def getBlocks # {{{

    Dir.new($BLOCK_PATH).entries.select{|d| d =~ /.*\.#{$BLOCK_POSTFIX}$/ }.each {|d|}

end # }}}



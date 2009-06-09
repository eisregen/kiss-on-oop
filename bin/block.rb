#
# class Block
#
#   'Block' representates a block. Through the different methods it works as an
#   layer between the several files per block and the application itself.
#
#   also it is planned to use different types of Blocks which can derive from
#   Block. This would cause a great modularity.
#

# TODO: outsourcing
# helper for name validation, returns true if name ok
def validate (name) # {{{
    (blockname =~ /^\w+$/)
end # }}}




class Block # {{{

    def initialize (blockname) # {{{
        if validate blockname
            @blockname = blockname
        else
            raise ArgumentError, "blockname invalid"
        end
    end # }}}

    def dump # {{{
        
    end # }}}

    def load # {{{
    end # }}}

end # }}}


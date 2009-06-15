#
# class TextBlock
#
#   Author: Jakob Holderbaum
#
#   The first BlockModule. It implements just a little textile wrapper. The
#   source of the Block is on HTMLrequest parsed with the RedCloth-textile lib.
#

module CMS

    module BlockModules

        require File.join('cms','Core','Block')
        require File.join('cms','Utils','Utils')

        class TextBlock < Core::Block
            def initialize (blockname)
                super(blockname)
                @author      = 'Jakob Holderbaum'
                @title       = 'TextBlock'   
                @description = 'A simple textile Parser'
                @additional  = 'needs the RedCloth gem'
            end

            def html
                puts 'HTML: '+@blocksrc
                return Utils.textile @blocksrc
            end
        end

    end

end

#
# class TextBlock
#
#   Author: Jakob Holderbaum
#
#   The first BlockModule. It implements just a little textile wrapper. The
#   source of the Block is on HTMLrequest parsed with the RedCloth-textile lib.
#

module CMS

    module Core
        module BlockModules

            require File.join('cms','Core','Block')
            require File.join('cms','Utils','Utils')

            class TextBlock

                AUTHOR      = 'Jakob Holderbaum'
                TITLE       = 'TextBlock'   
                DESCRIPTION = 'A simple textile Parser'
                ADDITIONAL  = 'needs the RedCloth gem'

                def initialize (blockname,blocktitle,blocksrc)
                    @blockname = blockname
                    @blocksrc = blocksrc
                end

                def html
                    return Utils.textile @blocksrc
                end

                def afterLoad
                end

                def afterDump
                end

                def beforeDeletion
                end

            end

        end
    end

end

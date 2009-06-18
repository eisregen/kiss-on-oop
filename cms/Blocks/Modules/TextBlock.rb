#
# class TextBlock
#
#   Author: Jakob Holderbaum
#
#   The first BlockModule. It implements just a little textile wrapper. The
#   source of the Block is on HTMLrequest parsed with the RedCloth-textile lib.
#

module CMS

  module Blocks
    module Modules

      require File.join('cms','Blocks','Blocks')
      require File.join('cms','Utils','Utils')

      class TextBlock

        AUTHOR      = 'Jakob Holderbaum'
        TITLE       = 'TextBlock'   
        DESCRIPTION = 'A simple textile Parser'
        ADDITIONAL  = 'needs the RedCloth gem'

        def initialize (blockname,blocktitle,blocksrc)
          @blockname = blockname
          @blocktitle= blocktitle
          @blocksrc = blocksrc
        end

      end

    end
  end

end

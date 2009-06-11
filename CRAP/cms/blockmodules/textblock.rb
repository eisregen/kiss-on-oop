#
# class TextBlock
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#   
#   TextBlock is the first an mainly for developing created blockmodule for
#   KISS-CMS. It should also be a simple example how to create own blockmodules
#

# this is required for every blockmodule, no exception
require 'core/block'
#

require 'core/utilities'



class TextBlock < Block # {{{
    
    def initialize (blockname,title) 
        super(blockname,title)
        # sets metainformation about this blockmodule
        @author = 'Jakob Holderbaum'
        @title = 'TextBlock'
        @description = 'The text you enter will be translated to HTML via textile'
        @additional = 'The best reference I know is on -- http://hobix.com/textile/'
    end 

    def html
        Util.textile @blocksrc
    end

end # }}}


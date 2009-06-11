#
# class AnswerBlock
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#   
#   answerBlock is the second blockmodule for KISS-CMS. It's so damn useless, 
#   as you can see, so we use it only, and realy only, for advanced testing purposes
#

# this is required for every blockmodule, no exception
require 'core/block'
#

require 'core/utilities'



class AnswerBlock < Block # {{{
    
    def initialize (blockname,title) 
        super(blockname,title)
        # sets metainformation about this blockmodule
        @author = 'Jakob Holderbaum'
        @title = 'answerBlock'
        @description = 'shame shame shame, this module is useless'
        @additional = 'Whats the answer?'
    end

    def html
        'What the hell? It\'s 42!'
    end

end # }}}


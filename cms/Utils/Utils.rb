module CMS
#
# bunch of wellused utilities
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kis on xinutec.org
#


require 'rubygems'
require 'RedCloth'

module Utils # {{{

    # checks the given argument against the defined validation rule
    # because of the savings as file, the names of blocks and pages shoud only
    # contain alphanumeric characters
    def Utils.valid? (name) # {{{
        name =~ /^\w+$/
    end # }}}

    # just a little wrapperfunction around the RedCloth textile onject.
    # it does not really improve the speed or soething like that, it is just for
    # the readability
   def Utils.textile (string) # {{{
       RedCloth.new(IO.readlines(blkfile).join).to_html
   end # }}}

end # }}}
end

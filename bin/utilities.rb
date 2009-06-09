#
# bunch of wellused utilities
#
#   Author: Jakob Holderbaum
#

module Utils # {{{

    # checks the given argument against the defined validation rule
    # because of the savings as file, the names of blocks and pages shoud only
    # contain alphanumeric characters
    def Utils.validate (name) # {{{
        name =~ /^\w+$/
    end # }}}

end # }}}


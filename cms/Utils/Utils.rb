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

    # just a little wrapperfunction around the RedCloth textile onject.  it does
    # not really improve the speed or something like that, it is just for
    # readability
    def Utils.textile (string) # {{{
        RedCloth.new(string).to_html
    end # }}}

    # Turns an Array of Strings into one String, separated by "\n"
    def Utils.unlines (array) # {{{
      array[0..-2].map{|x| x << "\n"} << array[-1]
    end # }}}

    # TODO: I think, get_tree should reside in Structure:: - but this is not
    # important for beta funcionality
    # Gets the tree structure as an array of Strings
    def Utils.get_tree (parent, struct = Structure::Structure.new.load) # {{{

      result = []
      struct.get_children(parent).each do |child|

        result <<= child
        if struct.has_children? child
          result.concat(get_tree(child).map {|s| " |-" + s})
        end

      end

      return result
    end # }}}

end # }}}
end

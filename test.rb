#!/usr/bin/ruby


module CMS


    require 'cms/Template/Template'

    tpl = Template::Template.new 'template.yaml'

    key = 'named'
    puts tpl.isKey? key
    puts tpl.getValue key

    puts tpl.getKeys

    puts 'yeeeeeeee'

    puts tpl.parse "yeeee {{name}}\n   aaaaa {{lulz}}"

end

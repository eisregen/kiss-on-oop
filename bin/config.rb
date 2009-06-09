require 'yaml'


# {{{ Configuration Class
class Configuration

    # Access to values
    attr_accessor :system
    attr_accessor :page
    attr_accessor :opts
    attr_accessor :html

    def initialize (filepath, defaults)

        config = YAML::load File.open(filepath)

        if defaults
            @conf = defaults.merge!(config)
        else
            @conf = config
        end


        # Set system values
        @system = CSystem.new(@conf["system"])

        # Page values
        @page   = CPage.new(@conf["page"].merge!(@conf["options"]))

        # HTML values
        @html   = CHTML.new(@conf["html"])

    end


end

# }}}


# {{{ System settings
class CSystem

    attr_accessor :html         # path of html files
    attr_accessor :pages        # path of page files
    attr_accessor :blocks       # path of block files
    attr_accessor :templates    # path of templates

    attr_accessor :order        # page order
    attr_accessor :extensions   # postfix file extension
    attr_accessor :editor       # editor

    def initialize (hash)

        # filepaths
        @html       = hash["paths"]["html"]
        @pages      = hash["paths"]["pages"]
        @blocks     = hash["paths"]["blocks"]
        @templates  = hash["paths"]["templates"]

        # other
        @order      = hash["page_order"]
        @extensions = hash["extensions"]
        @environment = hash["environment"]

    end

end

# }}}

# {{{ Page settings
class CPage

    attr_accessor :title        # page title
    attr_accessor :description  # description
    attr_accessor :author       # author
    attr_accessor :copyright    # copyright
    attr_accessor :append       # append title?
    attr_accessor :separator    # maintitle separator

    def initialize (hash)

        # Asign values
        @title      = hash["title"]
        @description = hash["description"]
        @author     = hash["author"]
        @copyright  = hash["copyright"]

        # Other options
        @append     = hash["app_title"]
        @separator  = hash["separator"]

    end
end

# }}}

# {{{ HTML Settings
class CHTML

    # Placeholders
    attr_accessor :title
    attr_accessor :navigation
    attr_accessor :author
    attr_accessor :date
    attr_accessor :dateformat

    # CSS stuff
    attr_accessor :css_nav
    attr_accessor :css_nav_elem_sel
    attr_accessor :css_nav_elem_unsel

    def initialize (hash)

        # Placeholders
        @title      = hash["title"]
        @navigation = hash["navigation"]
        @author     = hash["author"]
        @date       = hash["date"]
        @dateformat = hash["dateformat"]

        # CSS stuff
        @css_nav        = hash["css_nav"]
        @css_elem_sel   = hash["css_elem_sel"]
        @css_elem_unsel = hash["css_elem_unsel"]
    end

end

# }}}


#
# class Configuration
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de
#
#   The "Configuration" class Offers an easy way for the configuration of the
#   KISS-CMS.
#
#   TODO: Test set!
#         (more)
#

require 'yaml'


# {{{ Configuration Class
class Configuration

    # Access to values
    attr_accessor :system
    attr_accessor :page
    attr_accessor :opts
    attr_accessor :html

    def initialize (filepath, defaults = nil)

        if not filepath
            puts "No filepath given"
            return
        end


        # Load filepath
        @conf = YAML::load File.open(filepath)

        # Set system values
        @system = CSystem.new(@conf["system"]) if @conf["system"]

        # Page values
        @page   = CPage.new(@conf["page"], @conf["options"]) if @conf["page"]

        # HTML values
        @html   = CHTML.new(@conf["html"]) if @conf["html"]


        # Merge defaults with user config
        if defaults
            @conf = defaults.setConfig!(@conf)
        end

    end

    # TODO
    # Set values of another config
    def setConfig! (other)
        @system.set!(other.system)
        @page.set!(other.page)
        @html.set!(other.html)
    end

end

# }}}


# {{{ System settings
class CSystem

    attr_accessor :path         # path of the files -> Hash!
    attr_accessor :extensions   # postfix file extension -> Hash!

    attr_accessor :order        # page order
    attr_accessor :editor       # editor

    def initialize (hash)

        # filepaths
        @path       = hash["paths"] if hash["paths"] # Hash!
        @extensions = hash["extensions"] if hash["extensions"] # Hash!

        # other
        @order      = hash["page_order"] if hash["page_order"]
        @editor     = hash["editor"] if hash["editor"]

    end


    # Set values of other CSystem (Warning: Changes current settings)
    def set! (other)

        # merge hashes
        @path       = @path.merge(other.path) if other.path
        @extensions = @extensions.merge(other.extensions.merge) if other.extensions

        # set rest
        @order      = other.order if other.order
        @editor     = other.editor if other.editor

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

    def initialize (hashPage, hashOpts)

        # Asign values
        @title      = hashPage["title"] if hashPage["title"]
        @description = hashPage["description"] if hashPage["description"]
        @author     = hashPage["author"] if hashPage["author"]
        @copyright  = hashPage["copyright"] if hashPage["copyright"]

        # Other options
        @append     = hashOpts["app_title"] if hashOpts["app_title"]
        @separator  = hashOpts["separator"] if hashOpts["separator"]

    end


    # Set values of other CPage (Warning: Changes current settings!)
    def set! (other)

        @title      = other.title if other.title
        @description = other.description if other.description
        @author     = other.author if other.author
        @copyright  = other.copyright if other.copyright

        # Other options
        @append     = other.append if other.append
        @separator  = other.separator if other.separator

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
    attr_accessor :css  # -> Hash!

    def initialize (hash)

        # Placeholders
        @title      = hash["title"] if hash["title"]
        @navigation = hash["navigation"] if hash["navigation"]
        @author     = hash["author"] if hash["author"]
        @date       = hash["date"] if hash["date"]
        @dateformat = hash["dateformat"] if hash["dateformat"]

        # CSS stuff
        @css        = hash["css"] if hash["css"] # Hash
    end


    # Set values of other CHTML (Warning: Changes current settings!)
    def set! (other)

        # Placeholders
        @title      = other.title if other.title
        @navigation = other.navigation if other.navigation
        @author     = other.author if other.author
        @date       = other.date if other.date
        @dateformat = other.dateformat if other.dateformat

        # Merge CSS Hash
        @css        = @css.merge(other.css) if other.css

    end


end

# }}}


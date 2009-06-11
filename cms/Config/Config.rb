#
# class Configuration
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de
#
#   The "Configuration" class Offers an easy way for the configuration of the
#   KISS-CMS.
#
#   You shouldn't need direct access to this module since all the settings are
#   loaded in cms/Config/Settings. See Settings.rb for more informations.
#

module CMS
    module Config

        require 'yaml'


        # {{{ Configuration Class
        class Configuration

            # Access to values
            attr_accessor :system
            attr_accessor :page
            attr_accessor :opts
            attr_accessor :html

            # filepath -> String
            # defaults -> Configuration
            def initialize (filepath, defaults = nil)

                if not filepath
                    puts "No filepath given"
                    return
                end

                # Load filepath
                @conf = YAML::load File.open(filepath)

                # Set values
                @system = CSystem.new(@conf["system"])               if @conf["system"]
                @page   = CPage.new(@conf["page"], @conf["options"]) if @conf["page"]
                @html   = CHTML.new(@conf["html"])                   if @conf["html"]


                # Merge defaults with user config
                if defaults
                    defaults.setConfig!(self)
                    @system = defaults.system
                    @page   = defaults.page
                    @html   = defaults.html
                end

            end

            # Set values of another config
            def setConfig! (other)
                if @system
                    @system.set!(other.system)  if other.system
                else
                    @system = other.system
                end
                if @page
                    @page.set!(other.page)      if other.page
                else
                    @page = other.page
                end
                if @html
                    @html.set!(other.html)      if other.html
                else
                    @html = other.html
                end
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
                if @path
                    @path       = @path.merge(other.path)             if other.path
                else
                    @path       = other.path
                end

                if @extensions
                    @extensions = @extensions.merge(other.extensions) if other.extensions
                else
                    @extensions
                end

                # set rest
                @order      = other.order   if other.order
                @editor     = other.editor  if other.editor

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
                if @css
                    @css    = @css.merge(other.css) if other.css
                else
                    @css    = other.css
                end

            end


        end

    end

end

# }}}

#
# Settings module
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de
#
#   This module offers the settings for the KISS-CMS.
#   Access these settings with
#
#       require 'cms/Config/Settings'
#
#       Config::SYSTEM.editor = "vim"
#       Config::PAGE.title = "New title"
#
#   etc...
#

module CMS
    module Config

        require 'cms/Config/Config'

        # Load defaults
        defaults   = Config::Configuration.new("cms/Config/defaults.yaml")

        # Load user config and change default values
        config    = Config::Configuration.new("config.yaml", defaults)

        # Export settings
        SYSTEM = config.system
        PAGE   = config.page
        HTML   = config.html

    end
end
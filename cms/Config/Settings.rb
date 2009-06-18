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

        require File.join('cms','Config','Config')

        # Load defaults
        config = Config::Configuration.new.load

        # Load user config and change default values
        user   = Config::Configuration.new.load('config.yaml')
        config.setConfig!(user)

        # Export settings
        SYSTEM = config.system
        PAGE   = config.page
        HTML   = config.html

    end
end

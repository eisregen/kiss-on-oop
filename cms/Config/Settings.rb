module CMS
module Settings

    require 'Config'

    $defaults   = Config::Configuration.new("defaults.yaml")

    $neu        = Config::Configuration.new("neu.yaml", $defaults)

end
end

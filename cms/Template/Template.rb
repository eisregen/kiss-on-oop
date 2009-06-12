#
# class Template
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#
#   ...

module CMS
    module Template

        require 'yaml'

        class Template

            def initialize (config)
                if not File.exist? config
                    puts 'file doesn\'t exist'
                else
                    tpl = YAML::load_file config
                    if tpl['substitution']
                        @constants = Hash.new
                        tpl['substitution'].each do |key,value|
                            @constants[key] = value
                        end
                    else
                        puts 'substitution segment not found'
                    end
                end
            end

            def isKey? (key)
                return true if @constants[key]
                return false
            end

            def getValue (key)
                if isKey? key
                    @constants[key]
                end
            end

            def getKeys
                keys = []
                @constants.each_key do |k|
                    keys << k
                end
                return keys
            end

            def setKey (key,value)
                @constants[key] = value
            end

            def parse (string)
                @constants.each do |k,v|
                    string.gsub!('{{'+k+'}}',v)
                    puts '{{'+k+'}} --> '+v
                end
                string
            end

            def parseRecursively (string)
            end

        end

    end
end

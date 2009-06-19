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

      def initialize (config = 'template.yaml')
        raise 'Configfile doesn\'t exist'           unless File.exist? config

        tpl = YAML::load_file config

        raise 'Substitution-segment doesn\'t exist' unless tpl['substitution']

        @constants = Hash.new
        tpl['substitution'].each do |key,value|
          @constants[key] = value
        end
      end

      def is_key? (key)
        if @constants[key]
      end

      def get_value (key)
        raise 'Key not found' unless isKey? key
        @constants[key]
      end

      def get_keys
        keys = Array.new
        @constants.each_key do |k|
          keys << k
        end
        keys
      end

      def set_key (key,value)
        @constants[key] = value
        self
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

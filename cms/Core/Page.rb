#
# class Page
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#
#   Page
#

module CMS
  module Core

    require File.join('cms','Config','Settings')

    require File.join('cms','Utils','Utils')
    require File.join('cms','Core','Block')

    PAGE_FILE_PATH = File.join('cms','Core','PageFiles','pages.yaml')

    class Page

      #attr_accessor :name
      #attr_accessor :title
      #attr_accessor :blocks

      def initialize (hash = nil, current = nil)
        @file = hash if hash.is_a? Hash
        @current = current if current.is_a? String
      end

      # {{{ Save and load

      def load (name, filepath = PAGE_FILE_PATH)
        # return a new page with the loaded data
        data = (YAML::load_file filepath) if File.exist? filepath
        Page.new data
      end

      def dump (filepath = PAGE_FILE_PATH)
        File.open(filepath, 'w') do |out|
          YAML::dump(@file, out)
        end

        # Return self
        self
      end

      # }}}

      # {{{ Questions

      # See if self is empty or not
      def empty?
        (not @file.is_a?(Hash)) || @file.empty?
      end

      # }}}

      # {{{ Get methods

      # Get the title (String) of a given page
      def title (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@file.key? name))
        @file[name]['title']
      end

      # Get the blocks (Array of String) of a given page
      def blocks (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@file.key? name))
        @file[name]['blocks']
      end

      # Get the names (Array of String) of every page
      def all_names
        return Array.new if self.empty?
        @file.keys
      end

      # }}}

      # {{{ Change values

      # Removes one page
      def rm_page (name)
        result = @file

        raise "No such page: #{name}" unless result.key? name

        result.delete_if {|k,v| k == name}
      end 

      # }}}

    end 



  end
end

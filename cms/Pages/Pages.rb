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
  module Pages

    require File.join('cms','Config','Settings')

    require File.join('cms','Utils','Utils')
    require File.join('cms','Blocks','Blocks')

    PAGES = File.join('cms','Pages','pages.yaml')
    FILE_PATH = File.join('cms','Pages','Files')

    class Pages

      #attr_accessor :name
      #attr_accessor :title
      #attr_accessor :blocks

      def initialize (hash = nil, current = nil)
        @source = hash if hash.is_a? Hash
        @current = current if current.is_a? String
      end

      # {{{ Save and load

      def load (filepath = PAGES)
        # return a new page with the loaded data
        data = (YAML::load_file filepath) if File.exist? filepath
        @source = data if data.is_a? Hash
        self
      end

      def dump (filepath = PAGES)
        File.open(filepath, 'w') do |out|
          YAML::dump(@source, out)
        end
      end

      # }}}

      # {{{ Questions

      # See if self is empty or not
      def empty?
        (not @source.is_a?(Hash)) || @file.empty?
      end

      # Does a page exist?
      def exist? (name)
        @source.key? name
      end

      # }}}

      # {{{ Get methods

      # Get the title (String) of a given page
      def title (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['title']
      end

      # Get the blocks (Array of String) of a given page
      def blocks (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['blocks']
      end

      # Get the names (Array of String) of every page
      def all_names
        return Array.new if self.empty?
        @source.keys
      end

      # }}}

      # {{{ Change values

      # Add one page
      def add_page (name, title, blocks)
        raise "Page already exists: #{name}" if @source.key? name

        @source[name] = {'title' => title, 'blocks' => blocks}

        self
      end

      # Removes one page
      def rm_page (name)
        raise "No such page: #{name}" unless @source.key? name

        @source.delete_if {|k,v| k == name}

        self
      end 

      # }}}

    end 



  end
end

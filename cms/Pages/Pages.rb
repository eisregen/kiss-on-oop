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

      def initialize (hash = nil, current = nil)
        @source = Hash.new
        @source = hash if hash.is_a? Hash
      end

      # {{{ Save and load

      # Load page source from file
      def load (filepath = PAGES)
        data = (YAML::load_file filepath) if File.exist? filepath
        @source = data if data.is_a? Hash
        self
      end

      # Save to YAML
      def dump (filepath = PAGES)
        File.open(filepath, 'w') do |out|
          YAML::dump(@source, out)
        end
      end

      # }}}

      # {{{ Questions

      # Does a page exist?
      def exist? (name)
        @source.key? name
      end

      # }}}

      # {{{ Get methods

      # Get the title (String) of a given page
      def get_title (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['title']
      end

      # Get the blocks (Array of String) of a given page
      def get_blocks (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['blocks']
      end

      # Get the type of a given page
      def get_type (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['type']
      end

      # Get the options of a given page
      def get_opts (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        return Array.new unless @source[name].key? "opts"
        @source[name]['opts']
      end

      # Get the names (Array of String) of every page
      def get_names
        return Array.new if self.empty?
        @source.keys
      end

      # }}}

      # {{{ Set methods

      # Set the name of a given page
      def set_name (name, newname)
        oldPage = @source[name]
        # Delete the old, add the new page with old content
        @source.delete name
        @source[newname] = oldPage
        self
      end

      # Set the title (String) of a given page
      def set_title (name,val)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['title'] = val
        self
      end

      # Set the type of a 
      def set_type (name, type)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['type'] = type
        self
      end

      # Set the blocks (Array of String) of a given page
      def set_blocks (name,val)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['blocks'] = val
        self
      end

      # Set options of a given page
      def set_opts (name, opts)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['opts'] = opts
      end

      # Set one single option to val
      def set_opt (name, opt, val)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['opts'] = Hash.new unless @source[name]['opts'].is_a? Hash
        @source[name]['opts'][opt] = val
        self
      end

      # {{{ Change values

      # Add one page
      def add_page (name, title, blocks)
        raise "Page already exists: #{name}" if @source.key? name

        @source[name] = {'title' => title, 'blocks' => blocks}

        self
      end

      # Remove one page
      def rm_page (name)
        raise "No such page: #{name}" unless @source.key? name

        @source.delete_if {|k,v| k == name}

        self
      end 

      # Set blocks
      def add_block (name,block)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        unless @source[name]['blocks'].is_a? Array
          @source[name]['blocks'] = [block]
        else
          @source[name]['blocks'] << block
        end
        self
      end

      # Remove opts
      def rm_opts (name)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name].delete 'opts'
      end

      # Merge existing with new opts
      def merge_opts (name, opts)
        raise "No such page: #{name}" unless ((not self.empty?) && (@source.key? name))
        @source[name]['opts'].merge opts
      end

      # }}}

      # }}}

    end 



  end
end

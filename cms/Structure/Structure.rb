#
# class Structure
#
#   Author:     Nils Schweinsberg
#   Contact:    mail (at) n-sch.de
#
#   The "Structure" class loads and safes the structure of all pages. You can
#   get the Children of a given Page.
#

require 'yaml'

module CMS

  require File.join('cms','Config','Settings')

  module Structure

    class Structure
      # path to the struct.yaml
      STRUCT_PATH = File.join('cms', 'Structure', 'struct.yaml')

      # Create Structure from a given Hash
      def initialize (hash = nil)
        @struct = Hash.new
        @struct = hash if hash.is_a? Hash
      end

      # {{{ Save and load

      # Load structure from filepath
      def load (filepath = STRUCT_PATH)
        data = (YAML::load_file filepath) if File.exist? filepath
        @struct = data if data.is_a? Hash
        self
      end

      # Save to YAML
      def dump (filepath = STRUCT_PATH)
        File.open(filepath, 'w') do |out|
          YAML::dump(@struct, out)
        end
      end

      # }}}

      # {{{ Get methods

      # Get the children of a given pagename
      def get_children (parent)
        raise "No such parent: #{parent}" unless @struct.key? parent
        @struct[parent]
      end

      # Get the parent of a given page
      def get_parent (name)
        if not self.is_elem? name
          raise "No such page: #{name}"
        end

        @struct.each { |p,c| return p.to_s if c.include? name }
      end

      # }}}

      # {{{ Questions

      # Has children?
      def has_children? (name)
        not self.get_children(name).empty?
      rescue
        false
      end

      # Is parent?
      def is_parent? (name)
        @struct.key? name
      rescue
        false
      end

      # Is element of the structure?
      def is_elem? (name)
        @struct.each{|key,list| return true if list.include? name }
      rescue
        false
      end

      # }}}

      # {{{ Change values

      # Add a page with a given parent
      def add_page (name, parent = nil)
        parent = 'top' if parent.nil? || parent.empty?

        # Raise error if name is already in structure
        if self.is_elem? name
          raise "Page already in structure: #{name}"

          # If parent already exist, add name to the list
        elsif self.is_parent? parent
          @struct[parent] << name

          # Add name to the parent list
        elsif self.is_elem? parent
          @struct[parent] = [name]

          # Create new 'top' if @struct is empty
        elsif self.is_empty? && parent == 'top'
          @struct = {parent => [name]}

          # Raise error
        else
          raise "No such parent: #{parent}"
        end

        self
      end


      # Remove a page, drop children (Warning: dont ask)
      def rm_page (name) # TODO
        # Raise error if name is not in structure
        raise "No such page: #{name}" unless self.is_elem? name

        # Drop parent
        if self.is_parent? name
          @struct.delete name
        end

        # Get parent of page and remove it
        parent = self.get_parent name
        @struct[parent].delete name

        self
      end

      # Move a page up down in the structure
      def mv_page (name, count)
        if not self.is_elem? name
          raise "No such page: #{name}"
        end

        # Get parent
        parent = self.get_parent name
        # Filter out name & insert at count-1 again
        @struct[parent].delete name
        n = count - 1
        @struct[parent] = (@struct[parent].take(n) << [name] << @struct[parent].drop(n)).flatten

        self
      end

      # }}}

    end
  end
end

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
        @struct = hash if hash.class == Hash
      end

      # {{{ Save and load

      # Load structure from filepath
      def load (filepath = STRUCT_PATH)
        Structure.new(YAML::load File.open(filepath, 'r'))
      end

      # Save to YAML
      def dump (filepath = STRUCT_PATH)
        File.open(filepath, 'w') do |out|
          YAML::dump(@struct, out)
        end
        self
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
        not (self.get_children(name).nil? || self.get_children(name).empty?)
      rescue
        false
      end

      # Is parent?
      def is_parent? (name)
        return false if @struct.nil? || @struct.empty?
        @struct.key? name
      end

      # Is element of the structure?
      def is_elem? (name)

        return false if @struct.nil? || @struct.empty?

        @struct.each do |key,list|
          if list.include? name
            return true
          end
        end

        return false
      end

      # Is structure empty?
      def is_empty?
        @struct.nil? || @struct.empty?
      end

      # }}}

      # {{{ Change values

      # Add a page with a given parent
      def add_page (name, parent = nil)
        parent = 'top' if parent.nil? || parent.empty?

        result = @struct


        # Raise error if name is already in structure
        if self.is_elem? name
          raise "Page already in structure: #{name}"

          # If parent already exist, add name to the list
        elsif self.is_parent? parent
          result[parent] << name

          # Add name to the parent list
        elsif self.is_elem? parent
          result[parent] = [name]

          # Create new 'top' if @struct is empty
        elsif self.is_empty? && parent == 'top'
          result = {parent => [name]}

          # Raise error
        else
          raise "No such parent: #{parent}"
        end

        Structure.new(result)
      end


      # Remove a page, drop children (Warning: dont ask)
      def rm_page (name) # TODO
        # Raise error if name is not in structure
        if not self.is_elem? name
          raise "No such page: #{name}"
        end

        result = @struct

        # Drop parent
        if self.is_parent? name
          result = result.drop name # drop :: Hash -> Int -> Hash - TODO
        end

        # Get parent of page and remove it
        parent = self.get_parent name
        result[parent] = result[parent].map{|x| x unless x == name}.compact

        Structure.new(result)
      end

      # Move a page up down in the structure
      def mv_page (name, count)
        if not self.is_elem? name
          raise "No such page: #{name}"
        end

        result = @struct

        # Get parent
        parent = self.get_parent name
        # Filter out name & insert at count-1 again
        result[parent] = result[parent].map{|x| x unless x == name}.compact
        n = count - 1
        result[parent] = (result[parent].take(n) << [name] << result[parent].drop(n)).flatten

        Structure.new(result)
      end

      # }}}

    end
  end
end

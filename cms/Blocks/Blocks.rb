#
# class Block
#
#   Author:     Jakob Holderbaum
#   Contact:    privat (at) techfolio.de | irc: #kiss on xinutec.org
#
#
#   'Block' representates a block. Through the different methods it works as an
#   layer between the several files per block and the application itself.
#
#   also it is planned to use different types of Blocks which can derive from
#   Block. This would cause a great modularity.
#
#   TODO:   all configuration parameters are listed below. they need to be
#           substituted through the config class
#

module CMS
  module Blocks

    require File.join('cms','Config','Settings')
    require File.join('cms','Utils','Utils')

    BLOCKS_PATH = File.join('cms','Blocks','blocks.yaml')
    FILE_PATH   = File.join('cms','Blocks','Files')
    MODULE_PATH = File.join('cms','Blocks','Modules')

    class Blocks

      def initialize (hash = nil) 

        @source = hash.is_a?(Hash) ? hash : Hash.new

      end 

      # {{{ Load and Save

      # Load from file
      def load (filepath = BLOCKS_PATH)

        raise "File not found: #{filepath}" unless File.exist? filepath

        @source = YAML::load_file filepath

        # Compare loaded Hash with existing files in cms/Blocks/Modules
        # Dont delete anything
        self.compare false
      end 

      # Save to file
      # TODO: delete files in cms/Blocks/Modules
      def dump (filepath = BLOCKS_PATH)
        # Compare saved Hash with existing files in cms/Blocks/Modules
        # Delete files which are not in the Hash anymore
        self.compare true

        # Save the .yaml
        File.open(filepath, 'w') do |out|
          YAML::dump(@source, out)
        end
      end 

      # }}}

      # {{{ Change values

      def set_blocktype (name, type)

        check_block name
        check_type type

        @source[name]['type'] = type

        self
      end

      # Remove block
      def rm_block name
        check_block name

        @source.delete_if {|k,v| k == name}

        self
      end 

      # Add a block
      def add_block (name, title, type)
        raise "Block already exists: #{name}" if @source.key? name

        @source[name] = {'title' => title, 'type' => type}
        self
      end

      # Update and compare cms/Blocks/Modules with @source
      def compare (delete = false, dirpath = MODULE_PATH)
        dir = Dir.new dirpath
        dir.each do |filename|
          break unless (filename =~ /^\./).nil?

          # Cut the .blk ending
          filename = filename[0..-5] unless (filename =~ /.+\.blk$/).nil?

          # filename is not in the @source yet
          unless @source.key? filename
            if delete # Delete the file if delete is true
              # TODO: Ask first
              puts "Removing block: #{filename}"
              File.delete(File.join(dirpath,filename))
            else # Otherwise, add the new block to the Hash
              puts "Adding new block: #{filename}"
              self.add_block(filename, String.new, nil)
            end
          end

        end

        self
      end

      # }}}

      # {{{ Get methods

      def get_blocktype (name)
        check_block name

        raise "No type set yet: #{name}" if @source[name]['type'].nil?
        @source[name]['type']
      end

      # }}}

      # {{{ Questions

      def exist? name
        @source.key? name
      end

      # Raise error if no such block
      def check_block name
        raise "No such block: #{name}" if @source.key? name
      end

      # Raise error if no such module
      def check_type type
        raise "No such type: #{type}" unless Modules.constants.include? type
      end

      # }}}

    end 
  end
end

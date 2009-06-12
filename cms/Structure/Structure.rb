#
# class Navigation
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
                @struct = hash
            end

            # Load structure from filepath
            def load (filepath = STRUCT_PATH)
                return Structure.new(YAML::load File.open(filepath, 'r'))
            end

            # Save to YAML
            def dump (filepath = STRUCT_PATH)
                File.open(filepath, 'w') do |out|
                    YAML::dump(@struct, out)
                end
                return self
            end

            # Get the children of a given pagename
            def getChildren (parent)
                raise "No such parent: #{parent}" if @struct[parent].nil?
                return @struct[parent]
            end

            # Has children?
            def hasChildren? (name)
                return (not self.getChildren(name).nil?)
            rescue
                return false
            end

            # Is parent?
            def isParent? (name)
                return @struct.key? name
            end

            # Is element of the structure?
            def isElem? (name)
                @struct.each do |key,list|
                    if list.include? name
                        return true
                    end
                end
                return false
            end


            # Add a page with a given parent
            def addPage (name, parent = nil)
                parent = 'top' if parent.nil? || parent.empty?

                if self.isElem? name
                    raise "Page already in structure: #{name}"
                end

                result = @struct
                if self.isParent? parent
                    result[parent] << name
                elsif self.isElem? parent
                    result[parent] = [name]
                else
                    raise "No such parent: #{parent}"
                end

                return Structure.new(result)
            end

            # Remove a page, drop children TODO
            #def rmPage (name)
                # if @struct[name].nil? && @struct['top']
            #end



            # Move a page up down in the structure
            def mvPage (name, count)
                #if not @struct.include(name)
                self.getParent(name) do |p|
                    if p.nil?
                        raise "Page not found: #{name}"
                    end # TODO
                end

                raise "Not implemented yet"
                # TODO newStruct = @struct[name][0..count - 2] << 

                return newStruct
            end
        end
    end
end

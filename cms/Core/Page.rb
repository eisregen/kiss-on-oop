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

        require File.join(Config::SYSTEM.path['root'],'Utils','Utils')
        require File.join(Config::SYSTEM.path['root'],'Core','Block')

        PAGE_FILE_PATH = File.join(Config::SYSTEM.path['root'],Config::SYSTEM.path['module'],Config::SYSTEM.path['pages'],Config::SYSTEM.path['page_file'])


        #    Dir.open(BLOCK_MODULE_PATH).select { |d| d =~ /.*\.rb$/ }.each do |f|
        #        require File.join(BLOCK_MODULE_PATH,f) 
        #    end


        # IT IS SITLL CLASS BLOCK FOR NOW, LITTLE COPYPASTA :P
        # {{{ Block definition
        class Page

            attr_accessor :pagename
            attr_accessor :pagetitle
            attr_accessor :blocks

            def initialize (pagename) # {{{
                @pagename = pagename
            end # }}}

            def exist?
              if not File.exist? PAGE_FILE_PATH
                # if the yaml file doesnt exist, no page exists
                return false
              else
                # otherwise load the file
                pagefile = YAML::load_file PAGE_FILE_PATH
                if pagefile.include? @pagename
                    return true
                end
              end

              return false
            end

            def dump # {{{
                if @blocks
                    if not File.exist? PAGE_FILE_PATH
                        # if the yaml file doesnt exist, create an empty list,
                        pagefile = []
                    else
                        # otherwise load the file
                        pagefile = YAML::load_file PAGE_FILE_PATH
                    end

                    # adds the metainformation to the yaml-file TODO: file modifier oO
                    if pagefile.include? @pagename
                        i = pagefile.index @pagename
                    end
                    pagefile += [@pagename,[@pagetitle,@blocks]]

                    File.open(PAGE_FILE_PATH, 'w') do |out|
                        YAML::dump(pagefile, out )
                    end
                    return true
                end
                false
            end # }}}

            def load # {{{
                # get metainformation
                pagefile = YAML::load_file PAGE_FILE_PATH
                if index=pagefile.index(@pagename)
                    @pagetitle = pagefile[index+1][0]
                    @blocks = pagefile[index+1][1]
                end

            end # }}}

            # removes all the crap..
            def delete # {{{
                pagefile = YAML::load_file PAGE_FILE_PATH
                pagefile -= [@pagename,[@pagetitle,@blocks]]

                File.open(PAGE_FILE_PATH, 'w') do |out|
                    YAML.dump(pagefile, out )
                end

            end # }}}

            def html # {{{
                html = ''
                @blocks.each do |block|
                   blk = Core::Block.new block
                   blk.load
                   html+=blk.html+"\r\n\r\n"
                end
                return html
            end # }}}

        end # }}}



    end
end

#!/usr/bin/ruby

#
# The 'shell'
#   
#   This file is the interface for the user. As mentioned in the README, the
#   arguments are passed into the Userspace with slighly modifications and verifications.
#
#   If the first argument equals a mathod in Userspace, this method is called
#   with all the following arguments as an argument array.
#
#   If the first equals 'help' a list of all Userspace-methods whith the ouptput
#   of there corresponding description-methods will be shown.
#
#   The help argument can be followed by a method name. In this case, the
#   help-method of the given method is calles with all following
#   commandlinearguments in one given array.
#

module CMS

  require (File.join('cms','Structure','Structure'))
  require (File.join('cms','Pages','Pages'))
  require (File.join('cms','Blocks','Blocks'))
  #require (File.join('cms','Templates','Templates'))
  # Load environments: Structure, Pages, Blocks, Templates
  STRUCT = Structure::Structure.new.load
  PAGES  = Pages::Pages.new.load
  BLOCKS = Blocks::Blocks.new.load
  #TEMPS  = Templates::Templates.new.load

  Dir.open(File.join('cms','Userspace')).select{ |f| f =~ /.*\.rb$/  }.each do |f|
    require(File.join('cms','Userspace',f[0..-4]))
  end

  if not ARGV[0]
    puts 'Type \''+__FILE__+'\' help for usage information'

  elsif ARGV[0] == 'help'
    if not ARGV[1]

      puts 'Possible commands are:'

      (Userspace.methods false).reject{|m| m=~ /.*\_help$/}.reject{|m| m=~ /.*\_description$/}.each do |m|
        print '\''+m+'\' '
        Userspace.send((m+'_description').to_sym)
      end

    elsif Userspace.methods.reject{|m| m=~ /.*\_help$/}.include? ARGV[1]
      if not ARGV[2]
        Userspace.send((ARGV[1]+'_help').to_sym,nil)
      else
        Userspace.send((ARGV[1]+'_help').to_sym,ARGV[2])
      end

    else
      raise 'Help not found'
    end

  else
    if Userspace.methods.reject{|m| m=~ /.*\_help$/}.include? ARGV[0]
      if not ARGV[1]
        Userspace.send(ARGV[0],nil)
      else
        Userspace.send(ARGV[0],ARGV[1..-1])
      end
    else
      raise 'Command not found'
    end
  end

#rescue => err
  #puts "An error occurred: #{err}"

end

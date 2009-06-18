#
# module Compose::Page
#
#   Compose a page into HTML
#
#   Author:   Nils Schweinsberg
#   Contact:  mail (at) n-sch.de | irc: #kiss on xinutec.org
#

module CMS
  module Compose

    def compose_page (page)
      html = String.new
      page.blocks.each do |block|
        html += Core::Block.new(block).load.html
      end
    end

  end
end

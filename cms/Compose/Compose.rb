#
# will be done L8R
#
#

module CMS
  module Compose

    require File.join('cms','Config','Settings')

    require File.join('cms','Utils','Utils')
    require File.join('cms','Blocks','Blocks')
    require File.join('cms','Pages','Pages')

    
    
    def Compose.block_html name
      CMS::BLOCKS.get_src name
    end

    def Compose.head_html
      '<html><head><title>{{pagetitle}}</title></head><body><div>{{navigation}}</div>'
    end

    def Compose.foot_html
      '</body></html>'
    end

    def Compose.page_html name
      html = head_html

      CMS::PAGES.get_blocks(name).each do |block|
#        string += Compose.block_html(block)
#        puts CMS::BLOCKS.get_src block
#        puts Compose.block_html block
        html << Utils.textile(Compose.block_html block)
#        puts block
      end

      html += foot_html
    end

  end
end


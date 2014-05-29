module Radriar
  module Roar
    module Links
      def add_links(endpoint)
        links         = {}
        links[:self]  = { href: endpoint.request.path }
        links[:first] = { href: endpoint.first_page }
        links[:prev]  = { href: endpoint.previous_page }
        links[:next]  = { href: endpoint.next_page }
        links[:last]  = { href: endpoint.last_page}
        links
      end
    end
  end
end



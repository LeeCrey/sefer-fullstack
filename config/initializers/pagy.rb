require "pagy/extras/overflow"
require "pagy/extras/metadata"
require "pagy/extras/countless"

Pagy::DEFAULT[:items] = 10
Pagy::DEFAULT[:overflow] = :last_page

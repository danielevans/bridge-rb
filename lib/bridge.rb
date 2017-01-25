module Bridge
  autoload :Game, File.expand_path('../bridge/game', __FILE__)
  autoload :Card, File.expand_path('../bridge/card', __FILE__)
  autoload :Strain, File.expand_path('../bridge/strain', __FILE__)
  autoload :Rank, File.expand_path('../bridge/rank', __FILE__)
  autoload :Hand, File.expand_path('../bridge/hand', __FILE__)
  autoload :Player, File.expand_path('../bridge/player', __FILE__)
  autoload :Handler, File.expand_path('../bridge/handler', __FILE__)
  module Pbn
    autoload :DealHandAndEach, File.expand_path('../bridge/pbn/deal_hand_and_each', __FILE__)
    autoload :Subgame, File.expand_path('../bridge/pbn/subgame', __FILE__)
    autoload :GameParser, File.expand_path('../bridge/pbn/game_parser', __FILE__)
    autoload :SubgameMarshaller, File.expand_path('../bridge/pbn/subgame_marshaller', __FILE__)
    autoload :PbnParserState, File.expand_path('../bridge/pbn/parser_states/pbn_parser_state', __FILE__)
    autoload :OutsideTagAndSection, File.expand_path('../bridge/pbn/parser_states/outside_tag_and_section', __FILE__)
    autoload :BeforeFirstTag, File.expand_path('../bridge/pbn/parser_states/before_first_tag', __FILE__)
    autoload :BeforeTagName, File.expand_path('../bridge/pbn/parser_states/before_tag_name', __FILE__)
    autoload :InTagName, File.expand_path('../bridge/pbn/parser_states/in_tag_name', __FILE__)
    autoload :BeforeTagValue, File.expand_path('../bridge/pbn/parser_states/before_tag_value', __FILE__)
    autoload :InTagValue, File.expand_path('../bridge/pbn/parser_states/in_tag_value', __FILE__)
    autoload :BeforeTagClose, File.expand_path('../bridge/pbn/parser_states/before_tag_close', __FILE__)
    autoload :InSupplementalSection, File.expand_path('../bridge/pbn/parser_states/in_supplemental_section', __FILE__)
    autoload :InAuctionSection, File.expand_path('../bridge/pbn/parser_states/in_auction_section', __FILE__)
    autoload :InSemicolonComment, File.expand_path('../bridge/pbn/parser_states/in_semicolon_comment', __FILE__)
    autoload :InCurlyComment, File.expand_path('../bridge/pbn/parser_states/in_curly_comment', __FILE__)
    autoload :InPlaySection, File.expand_path('../bridge/pbn/parser_states/in_play_section', __FILE__)
    autoload :InString, File.expand_path('../bridge/pbn/parser_states/in_string', __FILE__)
    autoload :BetweenTags, File.expand_path('../bridge/pbn/parser_states/between_tags', __FILE__)
    autoload :Done, File.expand_path('../bridge/pbn/parser_states/done', __FILE__)
  end
end

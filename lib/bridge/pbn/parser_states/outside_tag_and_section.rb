module Bridge
  module Pbn
    class OutsideTagAndSection < PbnParserState
      require 'bridge/pbn/parser_states/constants'
      include Bridge::Pbn::ParserConstants
      include Bridge::Pbn::ParserState

      def process_chars
        case parser.cur_char
          when ALLOWED_WHITESPACE_CHARS
            parser.inc_char
          when SEMICOLON
            parser.inc_char
            parser.state = InSemicolonComment.new(parser, self)
          when OPEN_CURLY
            parser.inc_char
            parser.state = InCurlyComment.new(parser, self)
          when OPEN_BRACKET
            parser.state = BeforeTagName.new(parser)
            parser.inc_char
          when SECTION_STARTING_TOKENS
            raise_exception if parser.state == BeforeFirstTag.new(parser)
            parser.state = if parser.tag_name == PLAY_SECTION_TAG_NAME
                             InPlaySection.new(parser)
                           elsif parser.tag_name == AUCTION_SECTION_TAG_NAME
                             InAuctionSection.new(parser)
                           else
                             InSupplementalSection.new(parser)
                           end
          else
            raise_exception
        end
      end

    end
  end
end

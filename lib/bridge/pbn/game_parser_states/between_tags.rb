module Bridge
  module Pbn
    class BetweenTags < OutsideTagAndSectionTemplate
      def add_comment(comment)
        parser.add_following_comment comment
      end
      def perhaps_yield
        parser.yield_subgame
      end
      def section_tokens_allowed
        true
      end
    end
  end
end
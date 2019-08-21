module Workarea
  module MailChimp
    class Gateway::List < Gateway
      def initialize(list_id, email_interests_id)
        @list_id = list_id
        @email_interests_id = email_interests_id
      end

      # Get the interest groups for the default list.
      #
      def interests
        begin
          response = MailChimp.request.lists(@list_id).interest_categories.retrieve

          response.body["categories"].map do |grouping|
            MailChimp::Group.new(
              _id: grouping["id"],
              name: grouping["title"],
              interests: groupings(grouping["id"])
            )
          end

        rescue StandardError => e
          message = "MAIL CHIMP ERROR: Error - #{e}"
          message += "Response - #{response['error']}" if response.is_a?(Hash)
          []
        end
      end

      private

        def groupings(category_id)
          response = MailChimp.request.lists(@list_id).interest_categories(category_id).interests.retrieve

          sort_by_display_order(response.body)
        end

        def sort_by_display_order(grouping)
          grouping["interests"].sort do |a, b|
            a["display_order"].to_i <=> b["display_order"].to_i
          end.each_with_object({}) do |interest, hash|
            hash[interest["id"]] = interest["name"]
          end
        end
    end
  end
end

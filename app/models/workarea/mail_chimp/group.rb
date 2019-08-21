module Workarea
  module MailChimp
    class Group
      include ApplicationDocument

      field :_id, type: String
      field :name, type: String
      field :interests, type: Hash

      embedded_in :user, class_name: "Workarea::User"

      validate :id_or_name

      def self.email_interests
        MailChimp.gateway.get_default_list_interests.first
      end

      def to_hash
        [_id, name, interests].hash
      end

      def to_s
        "#{name} (#{id}) - #{interests}"
      end

      def ==(other)
        self.name == other[:name] && self.interests == other[:interests]
      end

      private

        def id_or_name
          unless id.present? || name.present?
            self.errors[:base] << "An ID or Name is Required."
          end
        end
    end
  end
end

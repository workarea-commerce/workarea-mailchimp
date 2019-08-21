module Workarea
  module MailChimp
    class Gateway::SubscribeArgumentBuilder
      attr_reader :email, :options, :default_list_id, :email_interests_id

      def initialize(email, options, default_list_id, email_interests_id)
        @email = email
        @options = options
        @default_list_id = default_list_id
        @email_interests_id = email_interests_id
      end

      def build
        args = get_args(email, options[:user], default_list_options)
        merge_new_email(args, options)
      end

      private

        def merge_new_email(args, options)
          return args unless options[:new_email].present?
          args.merge(merge_vars: { email: options[:new_email] })
        end

        def default_list_options
          {
            id: default_list_id,
            double_optin: false,
            send_welcome: true,
            replace_interests: true,
            update_existing: true, # updating existing so we can make same API
            # call for new subscribers and existing subscribers
            email_type: "html" # other option is "text"
          }
        end

        def get_args(email, user = nil, options = {})
          group_merge = merge_groups({}, user)
          user_details_merge = merge_user_details({}, user)

          { email_address: email }.
            merge(options).
            merge(merge_fields: user_details_merge).
            merge(group_merge)
        end

        def merge_user_details(merge_vars, user)
          return merge_vars unless user.present?
          merge_vars[:FNAME] = user.first_name if user.first_name.present?
          merge_vars[:LNAME] = user.last_name if user.last_name.present?
          merge_vars
        end

        def merge_groups(merge_vars, user)
          if user&.groups.present?
            merge_vars.merge(interests: build_merged_groups(user.groups))
          else
            merge_vars.merge(interests: build_merged_groups(all_groups))
          end
        end

        def build_merged_groups(groups)
          hash = groups.first.interests.each_with_object({}) do |(id, _int), hsh|
            hsh[id] = true
          end
          all_interests.each do |id, int|
            hash[id] = false unless hash.keys.include?(id)
          end

          hash
        end

        def all_groups
          [default_group(group_interests)]
        end

        def all_interests
          group_interests.inject({}) { |aggregate, int| aggregate.merge(int.interests) }
        end

        def default_group(groups)
          default = groups.detect do |group|
            group.id == email_interests_id
          end

          default || groups.first
        end

        def group_interests
          key = "mail_chimp_email_interests/#{Workarea::MailChimp.config.default_store[:list_id]}"
          options = { expires_in: 1.hour }

          options.merge!(force: true) if Rails.cache.read(key).nil?

          Rails.cache.fetch(key, options) do
            Workarea::MailChimp.gateway.list.interests
          end
        end
    end
  end
end

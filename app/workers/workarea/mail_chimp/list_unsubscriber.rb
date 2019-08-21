module Workarea
  module MailChimp
    class ListUnsubscriber
      include Sidekiq::Worker
      include Sidekiq::CallbacksWorker

      sidekiq_options(
        enqueue_on: {
          Email::Signup => [:destroy],
          with: -> { [email] }
        },
        queue: "low",
        retry: true
      )

      def perform(email)
        User.find_by_email(email)&.update_attributes(email_signup: false)
        Workarea::MailChimp.gateway.unsubscribe(email)
      end
    end
  end
end

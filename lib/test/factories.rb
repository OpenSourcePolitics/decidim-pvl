# frozen_string_literal: true

FactoryBot.define do
  factory :reminder, class: "Decidim::Reminder" do
    user { build(:user) }
    component { build(:dummy_component, organization: user.organization) }
  end

  factory :reminder_record, class: "Decidim::ReminderRecord" do
    reminder { create(:reminder) }
    remindable { build(:dummy_resource) }
  end

  factory :reminder_delivery, class: "Decidim::ReminderDelivery" do
    reminder { create(:reminder) }
  end
end

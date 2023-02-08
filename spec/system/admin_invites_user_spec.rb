# frozen_string_literal: true

require "spec_helper"

describe "Admin invite user", type: :system do
  let(:organization) { create(:organization) }

  let!(:user) { create(:user, :admin, :confirmed, organization: organization) }

  before do
    switch_to_host(organization.host)
    login_as user, scope: :user
    visit decidim_admin.users_path
  end

  describe "Invite user" do
    before do
      click_link "New user"
    end

    it "shows the invite user form" do
      expect(page).to have_content("Invite participant as administrator")
      expect(page).to have_field("user_name", with: "")
      expect(page).to have_field("user_firstname", with: "")
      expect(page).to have_field("user_email", with: "")
    end


    it "invite user" do
      fill_in "user_name", with: "Doe"
      fill_in "user_firstname", with: "John"
      fill_in "user_email", with: "johndoe@example.org"
      click_button "Invite"

      expect(page).to have_content("Participant successfully invited.")
      expect(Decidim::User.find_by(email: "johndoe@example.org").reload.name).to eq("John Doe")
    end
  end
end

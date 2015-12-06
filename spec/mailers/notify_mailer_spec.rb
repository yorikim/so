require "rails_helper"

RSpec.describe NotifyMailer, type: :mailer do
  let!(:question) { create(:question) }

  describe "notify author" do
    let(:mail) { NotifyMailer.notify_author(question.user) }

    it "renders the headers" do
      expect(mail.subject).to eq "Notify author"
      expect(mail.to).to eq [question.user.email]
      expect(mail.from).to eq ["from@example.com"]
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Your question has changed")
    end
  end

  describe "notify followers" do
    let(:user) { create(:user) }
    let(:mail) { NotifyMailer.notify_followers(user) }

    it "renders the headers" do
      expect(mail.subject).to eq "Notify followers"
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ["from@example.com"]
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Question has changed")
    end
  end
end

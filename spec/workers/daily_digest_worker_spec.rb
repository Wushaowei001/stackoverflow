require 'spec_helper'

RSpec.describe DailyDigestWorker do
  describe '#perform' do
    let(:yesterday) { Time.now.midnight }
    let!(:topics) { create_list :topic, 2 }
    let!(:users) { create_list :user, 2 }
    let(:emails) do
      [
        topics[0].author.email, topics[1].author.email,
        users[0].email, users[1].email, Topic.last.author.email
      ]
    end

    it "call mailer with yesterday's questions", pending: true do
      Timecop.travel(Time.now + 1.day)
      create :topic
      expect(QuestionsMailer).to receive(:digest).with(topics, yesterday).and_call_original
      subject.perform
    end

    it 'sends email' do
      expect { subject.perform }
        .to change(ActionMailer::Base.deliveries, :size).by(1)
    end

    it 'sends digest' do
      subject.perform
      expect(ActionMailer::Base.deliveries.last.subject)
        .to match('New questions digest')
    end
  end

  # travis-ci incompatibility

  # describe 'scheduling' do
  #   let(:next_day_midnight) { Time.now.midnight + 1.day }
  #   let(:next_day_midday) { next_day_midnight + 12.hours }

  #   it 'runs next midnight' do
  #     expect(next_occurrence).to eq(next_day_midnight)
  #   end

  #   it 'runs 2nd day midnight' do
  #     allow(Time).to receive(:now).and_return(next_day_midday)
  #     expect(next_occurrence).to eq(next_day_midnight + 1.day)
  #   end

  #   def next_occurrence
  #     subject.class.schedule.next_occurrence
  #   end
  # end
end
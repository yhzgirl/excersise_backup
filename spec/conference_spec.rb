require "spec_helper"
require "conference"
require "talk"

describe Conference do 
	let!(:conference) { Conference.new }

	it { should respond_to(:tracks) }

	it { should respond_to(:schedule) }

	it { should respond_to(:add_new_track) }

	it { should respond_to(:schedule_generator) }

	it { should respond_to(:print_schedule) }

	it "has an am and pm track when created" do
		expect(conference.tracks).to eq([{ am: [], pm: [] }])
	end

	describe "#add_new_track" do
		it "adds am and pm tracks" do
			expect(conference.tracks).to eq([{ am: [], pm: [] }])
		end
	end

	describe "#add_talk" do
		let(:ruby_talk_in_60_min) { Talk.new("ruby talk", 60) }
		let(:testing_talk_in_60_min) { Talk.new("testing talk", 60) }
		let(:patterns_in_design_talk_in_90_min) { Talk.new("patterns in design talk", 90) }
		let(:mocking_behavior_talk_in_180_min) { Talk.new("mocking behavior talk", 180) }
		let(:fast_talk_in_5_min) { Talk.new("fast talk", "lightning") }

		before :each do
			conference.add_talk(ruby_talk_in_60_min)
			conference.add_talk(testing_talk_in_60_min)
		end

		it "if time left adds talk to am session" do
			expect(conference.tracks.last[:am].size).to eq(2)
		end

		it "will not add talk to am session if not enough time left" do
			conference.add_talk(patterns_in_design_talk_in_90_min)
			expect(conference.tracks.last[:am].size).to eq(2)
		end

		it "adds talk to pm session when am session is full" do
			conference.add_talk(patterns_in_design_talk_in_90_min)
			expect(conference.tracks.last[:pm].size).to eq(1)
		end

		it "creates new track when am and pm sessions of last track are full" do
			conference.add_talk(patterns_in_design_talk_in_90_min)
			conference.add_talk(mocking_behavior_talk_in_180_min)
			conference.add_talk(fast_talk_in_5_min)
			expect(conference.tracks.size).to eql(2)
		end
	end

	describe "#schedule_generator" do
		let(:ruby_talk_in_60_min) { Talk.new("ruby talk", 60) }
		let(:testing_talk_in_60_min) { Talk.new("testing talk", 60) }
		let(:patterns_in_design_talk_in_90_min) { Talk.new("patterns in design talk", 90) }
		let(:mocking_behavior_talk_in_180_min) { Talk.new("mocking behavior talk", 180) }
		let(:fast_talk_in_5_min) { Talk.new("fast talk", "lightning") }

		before :each do
			conference.add_talk(ruby_talk_in_60_min)
			conference.add_talk(testing_talk_in_60_min)
			conference.add_talk(patterns_in_design_talk_in_90_min)
			conference.add_talk(mocking_behavior_talk_in_180_min)
			conference.add_talk(fast_talk_in_5_min)
		end

		it "has adds tracks to schedule" do
			conference.schedule_generator
			expect(conference.schedule).to include("Track 1", "Track 2")
		end

		it "adds talks to schedule" do
			conference.schedule_generator
			expect(conference.schedule.size).to eq(11) #2 Tracks, 5 talks, 2 lunches, 2 networking events
		end

		it "adds lunch to schedule" do
			conference.schedule_generator
			expect(conference.schedule).to include(" 12:00PM Lunch")
		end
	end

	describe "#print_schedule" do
		let(:ruby_talk_in_60_min) { Talk.new("ruby talk", 60) }
			
		it "prints schedule to screen" do
			conference.add_talk (ruby_talk_in_60_min)
			conference.schedule_generator
			STDOUT.should_receive(:puts).exactly(4).times #Track, talk, lunch, network event
			conference.print_schedule
		end
	end
end
require "spec_helper"
require "talk"

describe Talk do
	let!(:talk) { Talk.new("ruby talk", 45) }

	it "has a name" do
		expect(talk.name).to eq("ruby talk")
	end

	it "has a length in minutes" do
		expect(talk.minutes).to eq(45)
	end

	it "if talk is a lightning talk it is 5 minutes" do
		thistalk = Talk.new("rspec talk", "lightning")
		expect(thistalk.minutes).to eq(5)
	end
end
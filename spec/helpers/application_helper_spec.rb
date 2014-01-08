require 'spec_helper'

describe ApplicationHelper do 

	it "gives you the difference in age between dates by the time interval you specify" do
		get_age(Time.zone.at(DateTime.now) - 3.days).should eq(3)
		get_age(Time.zone.at(DateTime.now) - 3.days, "days").should eq(3)
		get_age(Time.zone.at(DateTime.now) - 3.years, "years").floor.should eq(3)
		get_age(Time.zone.at(DateTime.now) - 3.days, "hours").should eq(72)
		get_age(Time.zone.at(DateTime.now) - 3.hours, "minutes").should eq(180)
		a_time = Time.zone.at(DateTime.now)
		get_age(a_time - 27.seconds, "seconds", a_time).should eq(27)
	end

	
end
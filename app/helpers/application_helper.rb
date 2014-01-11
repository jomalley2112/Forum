module ApplicationHelper

	def get_age(date_created, interval="days", curr_date=nil)
		curr_date ||= Time.zone.at(DateTime.now)
		case interval
		when "seconds"
			div_by = 1.second
		when "minutes"
			div_by = 1.minute
		when "hours"
			div_by = 1.hour
		when "days"
			div_by = 1.day
		when "years"
			div_by = 1.year
		else
			div_by = 1.day
		end
			
		(curr_date - date_created).to_i / div_by
	end

	def render_for_controller(partial, local_vars)
		#when a controller directly renders a partial you can't render a view after that
		render(:partial => partial, :locals => local_vars).html_safe
	end

end

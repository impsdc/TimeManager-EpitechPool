import moment from "moment";

export default class DateActions {
	/*
		Recupérer le premier et le dernier jour dune semaine ou d'un mois
		-----------------------------------------------------------------
		type = "days"/"week"/"month"
	*/
	static getDateRange = (type) => {
		let currentDate = moment();
		let weekStart = currentDate.clone().startOf(type);
		let weekEnd = currentDate.clone().endOf(type);
		if (type.includes("week")) {
			weekStart = weekStart.add(1, "days");
			weekEnd = weekEnd.add(1, "days");
		}

		let dateRange = {
			start: weekStart.format("YYYY-MM-DD HH:mm:ss"),
			end: weekEnd.format("YYYY-MM-DD HH:mm:ss"),
		};
		return dateRange;
	};

	/* 
		Recupérer le temps ecoulé entre 2 date;
		---------------------------------------
		start = "2021-10-25 00:17:29"
		end = "2021-10-25 00:17:29"
	*/
	static getTimeDuration = (start, end) => {
		let startT = moment(start);
		let endT = moment(end);
		let duration = moment.duration(endT.diff(startT));
		let hours = duration.asHours();
		return hours;
	};
}

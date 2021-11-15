import axios from "axios";
import moment from "moment";
import dateActions from "@/functions/dateFunctions";

export default class WorkingTimesAction {
	//=>WITH DATABASE
	static createWorkingTime = async (userID, start, end) => {
		let response = await axios.post(
			`${process.env.VUE_APP_API_URL}workingtimes`,
			{
				user_id: userID,
				start,
				end,
			},
			{
				withCredentials: true,
			}
		);
		return response;
	};

	static getWorkingTimes = async (userID, start, end) => {
		let response = await axios.get(
			`${process.env.VUE_APP_API_URL}workingtimes/${userID}?start=${start}&end=${end}`,
			{
				withCredentials: true,
			}
		);
		return response;
	};

	static updateWorkingTime = async (userID, workingTimeID, start, end) => {
		let response = await axios.put(
			`${process.env.VUE_APP_API_URL}workingtimes/${workingTimeID}`,
			{
				user_id: userID,
				start: start,
				end: end,
			},
			{
				withCredentials: true,
			}
		);
		return response;
	};

	static deleteWorkingTime = async (id) => {
		let response = await axios.delete(
			`${process.env.VUE_APP_API_URL}workingtimes/${id}`,
			{
				withCredentials: true,
			}
		);
		return response;
	};

	//=>WITHOUT DATABASE
	static fetchWorkingTimesData = async (id, startDate, endDate) => {
		let data = [];
		let labels = [];
		let datasetsData = [];
		let response = await this.getWorkingTimes(id, startDate, endDate);
		data = response.data.data;

		data.sort((a, b) => moment(a.start) - moment(b.start));

		data.map((item) => {
			let hours = dateActions.getTimeDuration(item.start, item.end);
			let day = moment(item.start).format("ddd D MMM YY");
			labels.push(day);
			datasetsData.push(Number.parseFloat(hours.toFixed(2)));
		});
		return { data, graphData: { labels, datasetsData } };
	};
}

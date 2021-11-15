import moment from "moment";
import userActions from "@/functions/usersFunctions";
import workingTimesAction from "@/functions/workingTimesFunctions";
import globalActions from "@/functions/globalFunctions";
import dateActions from "@/functions/dateFunctions";

const fkdatBDD2 = (id) => {
	[
		{
			start: "2021-11-01 09:30:00",
			end: "2021-11-01 19:00:00",
			user_id: id,
		},
		{
			start: "2021-11-03 09:30:00",
			end: "2021-11-03 15:00:00",
			user_id: id,
		},
		{
			start: "2021-11-05 09:30:00",
			end: "2021-11-05 21:50:00",
			user_id: id,
		},
		{
			start: "2021-11-09 10:17:29",
			end: "2021-11-09 17:17:29",
			user_id: id,
		},
		{
			start: "2021-11-10 10:30:00",
			end: "2021-11-10 23:42:00",
			user_id: id,
		},
		{
			start: "2021-11-11 08:50:00",
			end: "2021-11-11 20:00:00",
			user_id: id,
		},
		{
			start: "2021-11-12 10:17:00",
			end: "2021-11-12 17:17:00",
			user_id: id,
		},
	].map(async (item) => {
		await createWorkingTime(item.user_id, item.start, item.end);
		console.log(item);
	});
};

export default class AdminActions {
	static getAllWorkingTimesOfUsers = async (usersID, range) => {
		let allWorkingT = await Promise.all(
			usersID.map(async (it) => {
				let response = await workingTimesAction.getWorkingTimes(
					it,
					range.start,
					range.end
				);
				return { userID: it, data: response.data.data };
			})
		);

		let finalData = [];
		allWorkingT.map((workingTimes) => {
			workingTimes.data.map((it) => {
				let ret = { day: "", time: "", number: 1 };
				let hours = dateActions.getTimeDuration(it.start, it.end);
				ret.day = moment(it.start).format("ddd D MMM YY");
				ret.time = Number.parseFloat(hours.toFixed(2));
				let idx = finalData.findIndex((it) => it.day === ret.day);
				if (idx < 0) finalData.push(ret);
				else {
					finalData[idx].time += ret.time;
					finalData[idx].number += 1;
				}
			});
		});

		finalData.sort((a, b) => moment(a.day) - moment(b.day));

		let labels = finalData.map(({ day }) => day);
		let datasetsData = finalData.map((it) =>
			Number.parseFloat(it.time / it.number).toFixed(2)
		);

		return { labels, datasetsData };
	};

	static fetchDataForUsers = async (
		id,
		range,
		key = null,
		value = -1,
		usersList = null
	) => {
		let data = [];
		if (!usersList || usersList?.length < 0) {
			let response = await userActions.getAllUsers();
			usersList = response.data.data;
		}

		usersList = globalActions.listCleaner("id", id, usersList);
		if (key && value !== -1) {
			usersList = usersList.filter((it) => it[key] === value);
			console.log("filtred", key, value);
		}

		let allID = usersList.map(({ id }) => id);
		let { labels, datasetsData } = await this.getAllWorkingTimesOfUsers(
			allID,
			range
		);
		let graphData = { labels, datasetsData };

		return { data, graphData, users: usersList };
	};
}

import axios from "axios";

export default class TeamsActions {
	//=>WITH DATABASE
	static getTeam = async (teamID) => {
		let response = await axios.get(
			`${process.env.VUE_APP_API_URL}teams/${teamID}`,
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static getAllTeams = async () => {
		let response = await axios.get(`${process.env.VUE_APP_API_URL}teams`, {
			withCredentials: true,
		});

		console.log("response=>", response);
		return response;
	};

	static getAllTeamUsers = async (teamID) => {
		let response = await axios.get(
			`${process.env.VUE_APP_API_URL}users/team/${teamID}`,
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static createTeam = async (teamName) => {
		let response = await axios.post(
			`${process.env.VUE_APP_API_URL}teams`,
			{
				name: teamName,
			},
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static deleteTeam = async (teamID) => {
		let response = await axios.delete(
			`${process.env.VUE_APP_API_URL}teams/${teamID}`,
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static updateTeam = async (teamID, newTeamName) => {
		let response = await axios.post(
			`${process.env.VUE_APP_API_URL}teams/${teamID}`,
			{
				name: newTeamName,
			},
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	//=>WITHOUT DATABASE
	static getUsersOfTeams = async (teamIDs) => {
		let allUsersT = [];
		await Promise.all(
			teamIDs.map(async (it) => {
				let response = await this.getAllTeamUsers(it.id);
				allUsersT.push(...response.data.data);
			})
		);

		return allUsersT;
	};
}

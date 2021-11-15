import axios from "axios";

export default class UserActions {
	static loginUser = async (user) => {
		let response = await axios.post(
			`${process.env.VUE_APP_API_URL}login`,
			user,
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static logoutUser = async () => {
		let response = await axios.get(`${process.env.VUE_APP_API_URL}logout`, {
			withCredentials: true,
		});

		console.log("response=>", response);
		return response;
	};

	static createUser = async (user) => {
		let response = await axios.post(
			`${process.env.VUE_APP_API_URL}register`,
			user,
			{
				withCredentials: true,
			}
		);

		console.log("response=>", response);
		return response;
	};

	static updateUser = async (id, email, username, role, team) => {
		let response = await axios.put(
			`${process.env.VUE_APP_API_URL}users/${id}`,
			{
				email,
				username,
				role,
				team,
			},
			{ withCredentials: true }
		);
		console.log("response=>", response);
		return response;
	};

	static getUser = async (email, username) => {
		let response = await axios.get(
			`${process.env.VUE_APP_API_URL}users`,
			{
				params: {
					email,
					username,
				},
			},
			{ withCredentials: true }
		);
		return response;
	};

	static getUserByID = async (userID) => {
		let response = await axios.get(
			`${process.env.VUE_APP_API_URL}users/${userID}`,
			{ withCredentials: true }
		);
		return response;
	};

	static getAllUsers = async () => {
		let response = await axios.get(`${process.env.VUE_APP_API_URL}users`, {
			withCredentials: true,
		});
		return response;
	};

	static deleteUser = async (id) => {
		let response = await axios.delete(
			`${process.env.VUE_APP_API_URL}users/${id}`,
			{
				withCredentials: true,
			}
		);
		console.log("response=>", response);
		// getUser();
		return response;
	};

	static roleOfUser = ["Collaborateur", "Manager", "Président"];
}

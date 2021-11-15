import adminActions from "@/functions/adminFunctions";
import TeamsActions from "@/functions/teamsFunctions";

const roleConfig = {
	Collaborateur: {
		componentsVisible: {
			workingTimeTab: true,
			usersListTab: false,
		},
		functions: {},
	},
	Manager: {
		componentsVisible: {
			workingTimeTab: true,
			usersListTab: true,
		},
		adminDashboard: [
			{
				text: "de tous les utilisateurs de la team",
				value: 0,
				function: async (id, range) => {
					console.log("adminDashboard #0 Filtered by users");
					let response = await TeamsActions.getAllTeamUsers(1);
					let usersList = [...response.data.data];
					usersList = usersList.filter(
						(it) => it.role === 0 || it.role === 1
					);

					return await adminActions.fetchDataForUsers(
						id,
						range,
						null,
						null,
						usersList
					);
				},
			},
			{
				text: "d'utilisateur sélectionnés",
				value: 1,
				function: async (id, range, usersList) => {
					console.log("adminDashboard #1 Filtered by sltd teams");
					return await adminActions.fetchDataForUsers(
						id,
						range,
						null,
						null,
						usersList ? usersList : []
					);
				},
				functionMode: "TeamsUsers",
			},
		],
	},
	Président: {
		componentsVisible: {
			workingTimeTab: true,
			usersListTab: true,
		},
		adminDashboard: [
			{
				text: "de tous les Utilisateurs",
				value: 0,
				function: async (id, range) => {
					console.log("adminDashboard #0 Filtered by users");
					return await adminActions.fetchDataForUsers(id, range);
				},
			},
			{
				text: "de tous les Manageurs",
				value: 1,
				function: async (id, range) => {
					console.log("adminDashboard #1 Filtered by manager");
					return await adminActions.fetchDataForUsers(
						id,
						range,
						"role",
						1
					);
				},
			},
			{
				text: "de tous les Collaborateurs",
				value: 2,
				function: async (id, range) => {
					console.log("adminDashboard #2 Filtered by Collaborateurs");
					return await adminActions.fetchDataForUsers(
						id,
						range,
						"role",
						0
					);
				},
			},
			{
				text: "d'une team sélectionnées",
				value: 3,
				function: async (id, range, usersList) => {
					console.log("adminDashboard #3 Filtered by sltd teams");
					return await adminActions.fetchDataForUsers(
						id,
						range,
						null,
						null,
						usersList
					);
				},
				functionMode: "Teams",
			},
			{
				text: "d'utilisateur sélectionnés",
				value: 4,
				function: async (id, range, usersList) => {
					console.log("adminDashboard #4 Filtered by sltd users");
					return await adminActions.fetchDataForUsers(
						id,
						range,
						null,
						null,
						usersList
					);
				},
				functionMode: "Users",
			},
		],
		functions: {},
	},
};

export default roleConfig;

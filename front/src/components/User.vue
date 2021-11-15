<script>
	import Modal from "@/tools/Modal.vue";
	import Tableau from "@/tools/Tableau.vue";
	import UserActions from "@/functions/usersFunctions";

	export default {
		name: "User",
		components: {
			Modal,
			Tableau,
		},
		props: {
			data: Array,
			user: Object,
			refresh: Function,
		},
		data() {
			return {
				title: "User component",
				users: null,
				selecedUser: null,
				showModal: false,
			};
		},
		mounted() {
			console.log(this.data);
			if (this.data) this.users = this.data;
			// else this.getUser();
		},
		watch: {
			data: function () {
				this.users = this.data;
			},
		},
		methods: {
			async createUser(email, username, role, team) {
				let response = await UserActions.createUser({
					email,
					username,
					role,
					team,
				});
				return response;
			},
			async updateUser(id, email, username, role, team) {
				let response = await UserActions.updateUser(
					id,
					email,
					username,
					role,
					team
				);
				return response;
			},
			async getUser(email, username) {
				let response = await UserActions.getUser(email, username);
				console.log("response=>", response);
				this.users = response.data.data;
			},
			async getAllUsers() {
				let response = await UserActions.getAllUsers();
				this.users = response.data.data;
				return response;
			},
			async deleteUser(id) {
				let response = await UserActions.deleteUser(id);
				return response;
			},
			selectUserID(id) {
				console.log("toggleModal=>", id);
				this.selectedUser = null;
				if (id) {
					let index = this.users.findIndex((it) => it.id === id);
					this.selectedUser = this.users[index];
				}
				this.toggleModal();
			},
			async seeFunction(id) {
				console.log("see =>", id);
				this.$router.push({
					name: "DashboardUser",
					params: { userID: id },
				});
			},
			toggleModal() {
				this.showModal = !this.showModal;
			},
		},
	};
</script>

<template>
	<transition name="slide">
		<div class="hello">
			<div class="text-left">
				<button
					v-on:click="selectUserID()"
					class="
						bg-purple-500
						hover:bg-purple-700
						text-white
						font-bold
						py-2
						px-4
						rounded
						ml-0
					"
				>
					<div class="flex">
						<svg
							xmlns="http://www.w3.org/2000/svg"
							class="h-6 w-6 mr-5"
							fill="none"
							viewBox="0 0 24 24"
							stroke="currentColor"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
							/>
						</svg>
						<span> Ajouter un utilisateur </span>
					</div>
				</button>
			</div>
			<Tableau
				:titles="['ID', 'Username', 'Email', 'Team', 'Role']"
				:items="['id', 'username', 'email', 'team', 'role']"
				:lines="users"
				:see="seeFunction"
				:edit="selectUserID"
				:remove="deleteUser"
				:user="user"
			/>
			<Modal
				v-if="showModal"
				:add="createUser"
				:edit="updateUser"
				:user="selectedUser"
				:toggleModal="toggleModal"
				:refresh="refresh"
			/>
		</div>
	</transition>
</template>

<style scoped></style>

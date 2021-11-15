<script>
	import { useNotification } from "naive-ui";
	import UserActions from "@/functions/usersFunctions";
	import TeamsActions from "@/functions/teamsFunctions";
	import globalActions from "@/functions/globalFunctions";

	const ModalMode = {
		edit: { title: "Modifier", functionName: "edit" },
		create: { title: "Ajouter", functionName: "create" },
	};

	export default {
		name: "Modal",
		props: {
			user: Object,
			toggleModal: Function,
			add: Function,
			edit: Function,
			refresh: Function,
		},
		setup() {
			const notification = useNotification();

			return {
				ModalMode,
				notify(type, title, content) {
					let count = 10;
					notification.create({
						type,
						title,
						content,
						closable: true,
						duration: 10000,
						onAfterEnter: () => {
							const minusCount = () => {
								count--;
								if (count > 0) {
									window.setTimeout(minusCount, 1000);
								}
							};
							window.setTimeout(minusCount, 1000);
						},
					});
				},
			};
		},
		data() {
			let allRole = UserActions.roleOfUser.map((it, id) => ({
				id: id,
				name: it,
			}));
			return {
				mode: "create",
				newUser: {
					id: 0,
					username: "",
					email: "",
					role: 0,
					team: 0,
				},
				inputsItem: ["username", "email"],
				selectsItem: ["team", "role"],
				optionsItem: {
					role: [...allRole],
					team: null,
				},
			};
		},
		async mounted() {
			if (this.user) {
				this.newUser = { ...this.user };
				this.mode = "edit";
			}

			let reponse = await TeamsActions.getAllTeams();
			this.optionsItem.team = [...reponse.data.data];
		},
		methods: {
			async submitRequest() {
				if (
					!this.newUser.username ||
					!this.newUser.email ||
					!this.newUser.team
				) {
					console.log(
						this.newUser.username,
						this.newUser.email,
						this.newUser.role,
						this.newUser.team
					);
					this.notify("warning", "Votre action n'est pas valide !");
					return;
				}

				this.mode === "edit"
					? await this.editFnc()
					: await this.addingFnc();
			},

			async addingFnc() {
				await this.add(
					this.newUser.email,
					this.newUser.username,
					this.newUser.role,
					this.newUser.team
				)
					.then(() => {
						this.notify(
							"success",
							"Action validé !",
							`${
								this.newUser.username
							}, a été ajouté comme nouveau ${
								UserActions.roleOfUser[this.newUser.role]
							}.`
						);
						this.refresh();
						this.toggleModal();
					})
					.catch(() => {
						this.notify(
							"warning",
							"Votre action n'a pas été validée !"
						);
					});
			},

			async editFnc() {
				if (globalActions.arrayChanges(this.user, this.newUser)) {
					this.toggleModal();
					return;
				}

				await this.edit(
					this.newUser.id,
					this.newUser.email,
					this.newUser.username,
					this.newUser.role,
					this.newUser.team
				)
					.then(() => {
						this.notify(
							"success",
							"Action validé !",
							`Les informations de ${this.newUser.username} ont bien été modifiées.`
						);
						this.refresh();
						this.toggleModal();
					})
					.catch(() => {
						this.notify(
							"warning",
							"Votre action n'a pas été validée !"
						);
					});
			},
		},
		computed: {
			upCasing() {
				return (string) =>
					string.charAt(0).toUpperCase() + string.slice(1);
			},
		},
	};
</script>

<template>
	<div>
		<div
			class="
				overflow-x-hidden overflow-y-auto
				fixed
				inset-0
				z-50
				outline-none
				focus:outline-none
				justify-center
				items-center
				flex
			"
		>
			<!--content-->
			<div
				class="
					rounded-lg
					shadow-lg
					relative
					flex flex-col
					bg-white
					outline-none
					focus:outline-none
				"
			>
				<!--header-->
				<div
					class="
						flex
						items-start
						justify-between
						p-5
						border-b border-solid border-blueGray-200
						rounded-t
					"
				>
					<h3 class="text-3xl font-semibold">
						{{ ModalMode[this.mode].title }}
					</h3>
				</div>
				<!--body-->
				<div class="relative p-6 flex-auto">
					<form class="px-8 bg-white rounded">
						<div v-for="item in inputsItem" v-bind:key="item">
							<label
								class="
									block
									mb-2
									text-sm
									font-bold
									text-gray-700
								"
								for="email"
							>
								{{ upCasing(item) }}
							</label>
							<input
								v-model="this.newUser[item]"
								class="
									w-full
									px-3
									py-2
									mb-3
									text-sm
									leading-tight
									text-gray-700
									border
									rounded
									shadow
									appearance-none
									focus:outline-none focus:shadow-outline
								"
								id="items[index]"
								type="items[index]"
								:placeholder="upCasing(item)"
							/>
						</div>
						<!-- SElectorrs -->
						<div v-for="item in selectsItem" v-bind:key="item">
							<label
								class="
									block
									mb-2
									text-sm
									font-bold
									text-gray-700
								"
								for="email"
							>
								{{ upCasing(item) }}
							</label>
							<select
								v-model="this.newUser[item]"
								class="
									w-full
									px-3
									py-2
									mb-3
									text-sm
									leading-tight
									text-gray-700
									border
									rounded
									shadow
									appearance-none
									focus:outline-none focus:shadow-outline
								"
							>
								<option disabled value="">Choisissez</option>
								<option
									v-for="option in optionsItem[item]"
									v-bind:value="option.id"
									:key="option.id"
								>
									{{ option.name }}
								</option>
							</select>
						</div>
					</form>
				</div>
				<!--footer-->
				<div
					class="
						flex
						items-center
						justify-end
						p-6
						border-t border-solid border-blueGray-200
						rounded-b
					"
				>
					<button
						class="
							text-red-500
							bg-transparent
							active:bg-red-600
							font-bold
							uppercase
							text-sm
							px-6
							py-3
							rounded
							outline-none
							focus:outline-none
							mr-1
							mb-1
							ease-linear
							transition-all
							duration-150
						"
						type="button"
						v-on:click="toggleModal"
					>
						Annuler
					</button>
					<button
						class="
							text-purple-500
							bg-transparent
							border border-solid border-purple-500
							hover:bg-purple-500 hover:text-white
							rounded
							background-transparent
							font-bold
							uppercase
							px-6
							py-2
							text-sm
							outline-none
							focus:outline-none
							mr-1
							mb-1
							ease-linear
							transition-all
							duration-150
						"
						type="button"
						v-on:click="submitRequest"
					>
						Valider
					</button>
				</div>
			</div>
		</div>
		<div class="opacity-25 fixed inset-0 z-40 bg-black"></div>
	</div>
</template>

<style scoped></style>

<script>
	import storage from "@/functions/storageFunctions";
	import ChangePassword from "../components/changePassword.vue";
	import axios from "../tools/axios";
	import useNotificationFactory from "@/tools/Toast";

	const graphSelection = [
		{ name: "LineChart", asset: "ligne.png" },
		{ name: "BarChart", asset: "bas.png" },
		{ name: "PieChart", asset: "camembert.png" },
	];
	export default {
		name: "Settings",
		components: { ChangePassword },
		setup() {
			const notificationError = useNotificationFactory(
				"error",
				"Votre requête n'a pas aboutie"
			);

			const notificationSuccess = useNotificationFactory(
				"success",
				"Vos settings ont bien été mis à jour"
			);

			return {
				notificationSuccessLogout: useNotificationFactory(
					"success",
					"Vous avez bien été déconnectée"
				),
				graphSelection,
				notificationError,
				notificationSuccess,
			};
		},
		data() {
			return {
				selectedChart: null,
				selectedColor: null,
				user: storage.get("user"),
			};
		},
		async mounted() {
			await axios
				.get(`/users/${this.user.id}`, {
					withCredentials: true,
				})
				.then((response) => {
					this.selectedChart =
						response.data.data.chartType === null
							? "LineChart"
							: response.data.data.chartType;
					this.selectedColor =
						response.data.data.colorChart === null
							? "#8B5CF6"
							: response.data.data.colorChart;
				});
		},
		methods: {
			async logoutFuntion() {
				await axios.get("/logout").then((response) => {
					this.notificationSuccessLogout();
				});
				this.$router.push(`/login`);
				storage.remove("user");
			},
			async valideSelection(selection) {
				this.selectedChart = selection;
				console.log(selection);
				await storage.set(
					"user",
					JSON.stringify({
						...this.user,
						chartType: selection,
					})
				);
				this.selectedChart = selection;
			},
			async pushSelectedColor(event) {
				console.log(this.selectedColor);
				console.log(event);
				this.selectedColor = event.target.value;
				await storage.set(
					"user",
					JSON.stringify({
						...this.user,
						colorChart: event.target.value,
					})
				);
			},

			async handleClick() {
				console.log(this.selectedColor);
				console.log(this.selectedChart);
				axios
					.put(
						`/users/${this.user.id}`,
						{
							chartType: this.selectedChart,
							colorChart: this.selectedColor,
						},
						{
							withCredentials: true,
						}
					)
					.then((response) => {
						console.log(response);
						this.notificationSuccess();
					})
					.catch(() => {
						this.notificationError();
					});
			},

			async reset() {
				await axios
					.put(
						`/users/${this.user.id}`,
						{
							chartType: null,
							colorChart: null,
						},
						{
							withCredentials: true,
						}
					)
					.then((response) => {
						console.log(response);
						this.notificationSuccess();
						storage.set(
							"user",
							JSON.stringify({
								...this.user,
								colorChart: "#8B5CF6",
								chartType: "LineChart",
							})
						);
						this.selectedChart = "LineChart";
						this.selectedColor = "#8B5CF6";
					})
					.catch(() => {
						this.notificationError();
					});
			},
		},
	};
</script>

<template>
	<div
		class="
			flex
			items-start
			justify-between
			overflow-auto
			h-screen
			pb-24
			px-4
			md:px-6
		"
	>
		<div class="flex flex-col w-full pl-0 md:p-4 md:space-y-4">
			<div
				class="
					my-4
					shadow-lg
					px-4
					py-6
					w-full
					bg-white
					dark:bg-gray-700
					relative
					rounded-2xl
				"
			>
				<div class="flex items-center">
					<span class="rounded-xl relative p-2 bg-purple-100">
						<img width="25" height="25" src="@/assets/growth.png" />
					</span>
					<div class="flex flex-col">
						<span
							class="
								font-bold
								text-md text-black
								dark:text-white
								ml-2
							"
						>
							Paramètre des graphiques
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Sélecteur de couleur et de graphique
						</span>
					</div>
				</div>
				<div
					class="
						grid grid-cols-3
						md:grid-cols-3
						lg:grid-cols-3
						my-4
						align-center
					"
				>
					<div
						v-for="item of graphSelection"
						:key="item.name"
						class=""
					>
						<button
							class="shadow-lg rounded-2xl p-3"
							:class="[
								this.selectedChart === item.name &&
									'border-4 border-purple-500',
							]"
							v-on:click="valideSelection(item.name)"
						>
							<img
								width="150"
								:src="require('@/assets/' + item.asset)"
							/>
							<span class="mx-2 text-sm font-normal">
								{{ item.name }}
							</span>
						</button>
					</div>
				</div>
				<div class="flex items-center justify-between mb-6">
					<div
						class="
							flex
							items-center
							font-bold
							text-md text-black
							dark:text-white
							justify-between
						"
					>
						<p>Choisissez la couleur de votre graphique:</p>
						<input
							type="color"
							name="head"
							:value="selectedColor"
							@input="pushSelectedColor($event)"
						/>
					</div>
				</div>
				<div class="flex justify-between align-center">
					<button
						@click="handleClick"
						class="
							text-white
							font-bold
							py-2
							px-4
							rounded
							bg-purple-500
							hover:bg-purple-700
							mt-5
						"
					>
						<span>Confirmer votre selection</span>
					</button>
					<button
						@click="reset"
						class="
							text-white
							font-bold
							py-2
							px-4
							rounded
							bg-yellow-500
							hover:bg-yellow-700
							mt-5
						"
					>
						<span>Remettre les settings par défault</span>
					</button>
				</div>
			</div>
			<ChangePassword :id="this.user.id" />
			<div
				class="
					lg:invisible
					w-full
					my-4
					shadow-lg
					px-4
					py-6
					bg-white
					dark:bg-gray-700
					relative
					rounded-2xl
				"
			>
				<div class="flex items-center">
					<span
						class="
							rounded-xl
							relative
							p-2
							justify-center
							bg-purple-100
						"
					>
						<svg
							class="h-8 w-8 text-purple-600 ml-1"
							fill="none"
							viewBox="0 0 24 24"
							stroke="currentColor"
						>
							<path
								stroke-linecap="round"
								stroke-linejoin="round"
								stroke-width="2"
								d="M12.075,10.812c1.358-0.853,2.242-2.507,2.242-4.037c0-2.181-1.795-4.618-4.198-4.618S5.921,4.594,5.921,6.775c0,1.53,0.884,3.185,2.242,4.037c-3.222,0.865-5.6,3.807-5.6,7.298c0,0.23,0.189,0.42,0.42,0.42h14.273c0.23,0,0.42-0.189,0.42-0.42C17.676,14.619,15.297,11.677,12.075,10.812 M6.761,6.775c0-2.162,1.773-3.778,3.358-3.778s3.359,1.616,3.359,3.778c0,2.162-1.774,3.778-3.359,3.778S6.761,8.937,6.761,6.775 M3.415,17.69c0.218-3.51,3.142-6.297,6.704-6.297c3.562,0,6.486,2.787,6.705,6.297H3.415z"
							></path>
						</svg>
					</span>
					<div class="flex flex-col">
						<span
							class="
								font-bold
								text-md text-black
								dark:text-white
								ml-2
							"
						>
							Options
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Voici plus d'options.
						</span>
					</div>
				</div>
				<div class="dark:text-white my-4 flex flex-col">
					<button
						v-on:click="this.$router.push('/faq')"
						class="
							text-white
							font-bold
							py-2
							px-4
							rounded
							bg-purple-500
							hover:bg-purple-700
							mt-5
						"
					>
						<span>Questions Fréquentes</span>
					</button>
					<button
						v-on:click="logoutFuntion"
						class="
							text-white
							font-bold
							py-2
							px-4
							rounded
							bg-red-500
							hover:bg-red-700
							mt-5
						"
					>
						<span>Déconnection</span>
					</button>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
	label {
		font: 0.5rem "Fira Sans", sans-serif;
	}

	input {
		margin: 0.4rem;
	}

	h1 {
		font: 2rem "Fira Sans", sans-serif;
	}

	h2 {
		font: 1rem "Fira Sans", sans-serif;
	}
</style>

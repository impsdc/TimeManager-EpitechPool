<script>
	import { ref } from "vue";
	import axios from "axios";
	import moment from "moment";
	import { useRouter } from "vue-router";
	import WorkingTimes from "@/components/WorkingTimes.vue";
	import User from "@/components/User.vue";
	import roleConfig from "@/configs/roleConfig";
	import Storage from "@/functions/storageFunctions";
	import CustomSelect from "@/tools/CustomSelect.vue";

	import charts from "@/tools/charts/charts";
	import workingTimesAction from "@/functions/workingTimesFunctions";
	import dateActions from "@/functions/dateFunctions";
	import DateRangeSelector from "@/tools/DateRangeSelector.vue";
	import TeamSelector from "@/tools/TeamSelector.vue";

	export default {
		name: "DashboardAdmin",
		components: {
			WorkingTimes,
			User,
			CustomSelect,
			DateRangeSelector,
			TeamSelector,
		},
		setup() {
			const router = useRouter();
			const ROLEConfig = roleConfig;

			const currentRoute = ref(router.currentRoute._value.name);
			let user = Storage.get("user");

			if (user === null) router.push(`/login`);

			return {
				user,
				charts,
				currentRoute,
				ROLEConfig,
				isLoading: true,
				chartdata: null,
				options: [
					{ text: "Semaine", value: "week", actionToDo: false },
					{ text: "Mois", value: "month", actionToDo: false },
					{ text: "Définir", value: "toDefine", actionToDo: true },
				],
				selected: "week",
				selectedFilter: 0,
			};
		},
		data() {
			return {
				dateRange: {
					start: null,
					end: null,
				},
				users: null,
				selectedUsers: null,
			};
		},
		async mounted() {
			let range = dateActions.getDateRange(this.selected);
			this.dateRange = { ...range };
			await this.fetchDataFunction(range);
		},
		methods: {
			async fetchDataFunction(range) {
				let data = await this.ROLEConfig[
					this.user.roleTitle
				].adminDashboard[this.selectedFilter].function(
					this.user.id,
					range,
					this.selectedUsers
				);
				this.users = data.users;
				this.chartdata = data.graphData;
			},
			async selectOption(option) {
				console.log("selectOption");
				console.log("selectOption");
				console.log("selectOption");
				let range = dateActions.getDateRange(option);
				this.dateRange = { ...range };
				await this.fetchDataFunction(range);
			},
			async filterSelectOption(option) {
				console.log("filterSelectOption,option", option);
				this.selectedFilter = option;
				this.selectedUsers = null;
				await this.selectOption(this.selected);
			},
			async dateSelectorFunction(dates) {
				this.dateRange = { ...dates };
				console.log("dateSelectorFunction => dates=>", dates);
				await this.fetchDataFunction(dates);
			},
			async teamSelectorFunction(allID) {
				console.log("teamSelectorFunction => allID =>", allID.length);
				this.selectedUsers = allID;
				await this.fetchDataFunction(this.dateRange);
			},
			async refreshFunction() {
				console.log("refreshFunction=>");
				await this.fetchDataFunction(this.dateRange);
			},
		},

		computed: {
			dateFormater() {
				return (date) => moment(date).format("DD MMMM YYYY");
			},
		},
	};
</script>

<template>
	<div>
		<div class="overflow-auto h-screen pb-24 px-4 md:px-6">
			<header class="w-full h-16 z-40 flex items-center justify-between">
				<div class="block lg:hidden">
					<button
						class="
							flex
							p-2
							items-center
							rounded-full
							bg-white
							shadow
							text-gray-500 text-md
						"
					>
						<svg
							width="20"
							height="20"
							class="text-gray-400"
							fill="currentColor"
							viewBox="0 0 1792 1792"
							xmlns="http://www.w3.org/2000/svg"
						>
							<path
								d="M1664 1344v128q0 26-19 45t-45 19h-1408q-26 0-45-19t-19-45v-128q0-26 19-45t45-19h1408q26 0 45 19t19 45zm0-512v128q0 26-19 45t-45 19h-1408q-26 0-45-19t-19-45v-128q0-26 19-45t45-19h1408q26 0 45 19t19 45zm0-512v128q0 26-19 45t-45 19h-1408q-26 0-45-19t-19-45v-128q0-26 19-45t45-19h1408q26 0 45 19t19 45z"
							></path>
						</svg>
					</button>
				</div>
			</header>
			<h1 class="text-4xl font-semibold text-gray-800 dark:text-white">
				Dashboard Admin
			</h1>
			<h2 class="text-md text-gray-400">
				Vous pouvez retrouver l'ensemble des activités des utilisateurs
				ici.
			</h2>

			<h2 class="text-md underline text-gray-400 mt-3 mb-1">
				Filtrer les données en fonction:
			</h2>
			<div
				class="
					flex
					items-center
					text-gray-400 text-md
					border-gray-300 border
					px-4
					py-2
					rounded-tl-sm rounded-bl-full rounded-r-full
					justify-center
					mb-3
				"
			>
				<svg
					xmlns="http://www.w3.org/2000/svg"
					class="h-6 w-6"
					fill="none"
					viewBox="0 0 24 24"
					stroke="currentColor"
				>
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4"
					/>
				</svg>
				<select
					v-model="selectedFilter"
					@change="filterSelectOption($event.target.value)"
					class="bg-gray-100"
				>
					<option
						v-for="option in ROLEConfig[user.roleTitle]
							.adminDashboard"
						v-bind:value="option.value"
						:key="option.value"
					>
						{{ option.text }}
					</option>
				</select>
			</div>
			<div class="flex items-center space-x-4 mb-3">
				<div
					class="
						flex
						items-center
						text-gray-400 text-md
						border-gray-300 border
						px-4
						py-2
						rounded-tl-sm rounded-bl-full rounded-r-full
					"
				>
					<svg
						width="20"
						height="20"
						fill="currentColor"
						class="mr-2 text-gray-400"
						viewBox="0 0 1792 1792"
						xmlns="http://www.w3.org/2000/svg"
					>
						<path
							d="M192 1664h288v-288h-288v288zm352 0h320v-288h-320v288zm-352-352h288v-320h-288v320zm352 0h320v-320h-320v320zm-352-384h288v-288h-288v288zm736 736h320v-288h-320v288zm-384-736h320v-288h-320v288zm768 736h288v-288h-288v288zm-384-352h320v-320h-320v320zm-352-864v-288q0-13-9.5-22.5t-22.5-9.5h-64q-13 0-22.5 9.5t-9.5 22.5v288q0 13 9.5 22.5t22.5 9.5h64q13 0 22.5-9.5t9.5-22.5zm736 864h288v-320h-288v320zm-384-384h320v-288h-320v288zm384 0h288v-288h-288v288zm32-480v-288q0-13-9.5-22.5t-22.5-9.5h-64q-13 0-22.5 9.5t-9.5 22.5v288q0 13 9.5 22.5t22.5 9.5h64q13 0 22.5-9.5t9.5-22.5zm384-64v1280q0 52-38 90t-90 38h-1408q-52 0-90-38t-38-90v-1280q0-52 38-90t90-38h128v-96q0-66 47-113t113-47h64q66 0 113 47t47 113v96h384v-96q0-66 47-113t113-47h64q66 0 113 47t47 113v96h128q52 0 90 38t38 90z"
						></path>
					</svg>
					<select
						v-model="selected"
						@change="selectOption($event.target.value)"
						class="bg-gray-100"
					>
						<option
							v-for="option in options"
							v-bind:value="option.value"
							:key="option.value"
						>
							{{ option.text }}
						</option>
					</select>
				</div>
				<span class="text-sm text-gray-400">
					Du: {{ dateFormater(dateRange.start) }} - au:
					{{ dateFormater(dateRange.end) }}
				</span>
			</div>

			<div
				v-if="selected === 'toDefine'"
				class="
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
							Selecteur de date
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Veuillez saisir une date afin de filtre vos
							informations.
						</span>
					</div>
				</div>
				<div class="dark:text-white my-4">
					<DateRangeSelector :callBack="dateSelectorFunction" />
				</div>
			</div>

			<!-- v-if="selected === 'toDefine'" -->
			<div
				v-if="
					this.ROLEConfig[this.user.roleTitle].adminDashboard[
						this.selectedFilter
					].functionMode
				"
				class="
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
							Selecteur de date
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Veuillez saisir une date afin de filtre vos
							informations.
						</span>
					</div>
				</div>
				<div class="dark:text-white my-4">
					<TeamSelector
						:callBack="teamSelectorFunction"
						:user="this.user"
						:mode="
							this.ROLEConfig[this.user.roleTitle].adminDashboard[
								this.selectedFilter
							].functionMode
						"
					/>
				</div>
			</div>
			<!--- Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content-->
			<!--- GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH-->
			<div
				class="
					shadow-lg
					px-4
					py-6
					w-full
					my-4
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
							Temps de travail des utilisateurs selectionnés
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Graphique
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							(En cas de problème,
							<a
								href="#"
								class="
									hover:underline
									font-bold
									text-purple-500
								"
								v-on:click="this.$router.go()"
							>
								Cliquez ici
							</a>
							)
						</span>
					</div>
				</div>
				<div class="dark:text-white my-4">
					<component
						:is="
							charts[
								this.user.chartType
									? this.user.chartType
									: 'LineChart'
							]
						"
						:workingtimes="chartdata"
						:color="this.user.colorChart"
					/>
				</div>
			</div>

			<div
				class="
					shadow-lg
					px-4
					py-6
					w-full
					my-4
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
							Liste d'utilisateurs
						</span>
						<span
							class="text-sm text-gray-500 dark:text-white ml-2"
						>
							Tableau
						</span>
					</div>
				</div>
				<div class="dark:text-white my-4">
					<User
						:data="users"
						:refresh="refreshFunction"
						:user="this.user"
					/>
				</div>
			</div>

			<!-- Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid Grid-->
			<div
				class="
					grid grid-cols-1
					md:grid-cols-2
					lg:grid-cols-2
					gap-4
					my-4
				"
			>
				<!-- <div class="w-full">
					<div
						class="
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
						<p
							class="
								text-sm
								w-max
								text-gray-700
								dark:text-white
								font-semibold
								border-b border-gray-200
							"
						></p>
						<div class="flex items-end space-x-2 my-6">
							<p
								class="
									text-5xl text-black
									dark:text-white
									font-bold
								"
							></p>
							<span
								class="
									text-green-500 text-xl
									font-bold
									flex
									items-center
								"
							>
								<svg
									width="20"
									fill="currentColor"
									height="20"
									class="h-3"
									viewBox="0 0 1792 1792"
									xmlns="http://www.w3.org/2000/svg"
								>
									<path
										d="M1675 971q0 51-37 90l-75 75q-38 38-91 38-54 0-90-38l-294-293v704q0 52-37.5 84.5t-90.5 32.5h-128q-53 0-90.5-32.5t-37.5-84.5v-704l-294 293q-36 38-90 38t-90-38l-75-75q-38-38-38-90 0-53 38-91l651-651q35-37 90-37 54 0 91 37l651 651q37 39 37 91z"
									></path>
								</svg>
							</span>
						</div>
						<div class="dark:text-white"></div>
					</div>
				</div> -->
			</div>
		</div>
	</div>
</template>

<style></style>

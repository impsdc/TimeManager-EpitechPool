<script>
	import { ref } from "vue";
	import moment from "moment";
	import { useRouter, useRoute } from "vue-router";
	import ClockManager from "@/components/ClockManager.vue";
	import User from "@/components/User.vue";
	import WorkingTimes from "@/components/WorkingTimes.vue";
	import WorkingTime from "@/components/WorkingTime.vue";
	import Storage from "@/functions/storageFunctions";
	import roleConfig from "@/configs/roleConfig";
	import dateActions from "@/functions/dateFunctions";
	import workingTimesAction from "@/functions/workingTimesFunctions";
	import charts from "@/tools/charts/charts";
	import DateRangeSelector from "@/tools/DateRangeSelector.vue";

	export default {
		name: "Dashboard",
		components: {
			ClockManager,
			User,
			WorkingTimes,
			WorkingTime,
			DateRangeSelector,
		},
		setup() {
			const router = useRouter();
			const route = useRoute();
			const ROLEConfig = roleConfig;

			const currentRoute = ref(router.currentRoute._value.name);
			let user = Storage.get("user");
			// if (user === null) router.push(`/login`);

			return {
				currentRoute,
				user,
				ROLEConfig,
				charts,
				options: [
					{ text: "Semaine", value: "week", actionToDo: false },
					{ text: "Mois", value: "month", actionToDo: false },
					{ text: "Définir", value: "toDefine", actionToDo: true },
				],
				selected: "week",
			};
		},
		data() {
			return {
				active: true,
				data: null,
				chartdata: null,
				isLoading: true,
				dateRange: {
					start: null,
					end: null,
				},
			};
		},
		async mounted() {
			let range = dateActions.getDateRange(this.selected);
			this.dateRange = {
				start: moment(range.start).format("DD MMMM YYYY"),
				end: moment(range.end).format("DD MMMM YYYY"),
			};
			this.getWorkingTimes(range.start, range.end);
		},
		methods: {
			async getWorkingTimes(startDate, endDate) {
				this.isLoading = true;
				let allData = await workingTimesAction.fetchWorkingTimesData(
					this.user.id,
					startDate,
					endDate
				);
				this.data = allData.data;
				this.chartdata = allData.graphData;
				this.isLoading = false;
			},
			isChecked() {
				active = !active;
			},
			selectOption(option) {
				let range = dateActions.getDateRange(option);
				this.dateRange = {
					start: moment(range.start).format("DD MMMM YYYY"),
					end: moment(range.end).format("DD MMMM YYYY"),
				};
				this.getWorkingTimes(range.start, range.end);
			},
			updateAll() {
				console.log("updateAll");
				this.selectOption(this.selected);
			},
			async dateSelectorFunction(dates) {
				this.dateRange = {
					start: moment(dates.start).format("DD MMMM YYYY"),
					end: moment(dates.end).format("DD MMMM YYYY"),
				};
				console.log("dateSelectorFunction => dates=>", dates);
				this.getWorkingTimes(dates.start, dates.end);
			},
		},
	};
</script>

<template>
	<div id="theme" :class="[active ? '' : 'dark']" class="overflow-hidden">
		<div
			class="
				bg-gray-100
				dark:bg-gray-800
				h-screen
				overflow-hidden
				relative
			"
		>
			<div class="overflow-auto h-screen pb-24 px-4 md:px-6">
				<header
					class="w-full h-16 z-40 flex items-center justify-between"
				>
					<div class="block lg:hidden">
						<button
							class="
								flex
								p-2
								items-center
								rounded-full
								bg-white
								shadow
								text-gray-500
								dark:text-white
								text-md
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
				<h1
					class="
						text-4xl
						font-semibold
						text-gray-800
						dark:text-white
						pt-5
					"
				>
					Hello {{ user.username }},
				</h1>
				<h2 class="text-md text-gray-400 dark:text-white">
					Bienvenue sur votre espace utilisateur
				</h2>
				<div class="flex items-center space-x-4 my-3">
					<div
						class="
							flex
							items-center
							text-gray-400 text-md
							dark:text-white
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
							class="mr-2 text-gray-400 dark:text-white"
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
							class="bg-gray-100 dark:text-black"
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
					<span class="text-sm text-gray-400 dark:text-white">
						Du: {{ dateRange.start }} - au:
						{{ dateRange.end }}
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
							<img
								width="25"
								height="25"
								src="@/assets/growth.png"
							/>
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
								class="
									text-sm text-gray-500
									dark:text-white
									ml-2
								"
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
				<div
					class="
						self-end
						bg-red-100
						pt-5
						pb-5
						w-full
						rounded-2xl
						shadow-lg
					"
				>
					<ClockManager :id="this.user.id" />
				</div>
				<!--- Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content-->
				<!--- GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH GRAPH-->
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
							<img
								width="25"
								height="25"
								src="@/assets/growth.png"
							/>
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
								Temps de travail
							</span>
							<span
								class="
									text-sm text-gray-500
									dark:text-white
									ml-2
								"
							>
								Graphique
							</span>
							<span
								class="
									text-sm text-gray-500
									dark:text-white
									ml-2
								"
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
						<div class="flex items-center">
							<span class="rounded-xl relative p-2 bg-purple-100">
								<img
									width="25"
									height="25"
									src="@/assets/working.png"
								/>
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
									Ajoutez un temps de travail
								</span>
								<span
									class="
										text-sm text-gray-500
										dark:text-white
										ml-2
									"
								>
									Formulaire
								</span>
							</div>
						</div>

						<WorkingTime
							:userId="this.user.id"
							:update="updateAll"
						/>
					</div>

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
							row-span-2
						"
					>
						<div class="flex items-center">
							<span class="rounded-xl relative p-2 bg-purple-100">
								<img
									width="25"
									height="25"
									src="@/assets/growth.png"
								/>
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
									Temps de travail
								</span>
								<span
									class="
										text-sm text-gray-500
										dark:text-white
										ml-2
									"
								>
									Tableau
								</span>
							</div>
						</div>
						<WorkingTimes
							:id="this.user.id"
							:data="data"
							:update="updateAll"
						/>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style>
	.toggle-checkbox:checked {
		right: 0;
		border: none;
		background-color: rgb(129 124 214);
		background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' className='h-10 w-10' fill='%23FFF' viewBox='0 0 24 24' stroke='rgb(129 124 214)' > <path strokeLinecap='round' strokeLinejoin='round' d='M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z' /> </svg>");
	}
	.toggle-checkbox:checked + .toggle-label {
		background-color: rgb(76 73 188);
	}
	#facebook {
		display: none;
	}
	.mobile-hide {
		display: none;
	}

	@media screen and (min-width: 0px) and (max-width: 720px) {
		#facebook {
			display: block;
		}
		.mobile-hide {
			display: block;
		}
	}
</style>

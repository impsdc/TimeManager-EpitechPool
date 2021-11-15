<script>
	import moment from "moment";
	import { useNotification } from "naive-ui";
	import UserActions from "@/functions/usersFunctions";
	import globalActions from "@/functions/globalFunctions";

	export default {
		name: "Modal",
		props: {
			dateObj: Object,
			toggleModal: Function,
			edit: Function,
			refresh: Function,
		},
		setup() {
			const notification = useNotification();

			return {
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
			return {
				newDateObj: {
					id: null,
					selecteDate: null,
					startTime: null,
					endTime: null,
				},
			};
		},
		async mounted() {
			if (this.dateObj) {
				this.newDateObj.id = this.dateObj.id;
				this.newDateObj.selecteDate = moment(this.dateObj.start).format(
					"yyyy-MM-DD"
				);
				this.newDateObj.startTime = moment(this.dateObj.start).format(
					"HH:mm"
				);
				this.newDateObj.endTime = moment(this.dateObj.end).format(
					"HH:mm"
				);
			}
		},
		methods: {
			async submitRequest() {
				if (
					!this.newDateObj.selecteDate ||
					!this.newDateObj.startTime ||
					!this.newDateObj.endTime
				) {
					this.notify("warning", "Votre action n'est pas valide !");
					return;
				}

				await this.editFnc();
			},

			async editFnc() {
				if (globalActions.arrayChanges(this.dateObj, this.newDateObj)) {
					this.toggleModal();
					return;
				}

				let startR = `${this.newDateObj.selecteDate} ${this.newDateObj.startTime}:00`;
				let endR = `${this.newDateObj.selecteDate} ${this.newDateObj.endTime}:00`;
				if (startR > endR) {
					this.notify(
						"warning",
						"Votre action n'a pas été validée !"
					);
					return;
				}
				console.log(
					"this.newDateObj.id, startR, endR=>",
					this.newDateObj.id,
					startR,
					endR
				);
				await this.edit(this.newDateObj.id, startR, endR)
					.then(() => {
						this.notify(
							"success",
							"Action validé !",
							`Le temps de travail du de ${this.newDateObj.selecteDate} a bien été modifiées.`
						);
						this.refresh();
						this.toggleModal();
					})
					.catch(() => {
						this.notify(
							"error",
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
					<h3 class="text-3xl font-semibold">Modification</h3>
				</div>
				<!--body-->
				<div class="relative p-6 flex-auto">
					<form class="px-8 bg-white rounded">
						<label class="relative w-full flex flex-col my-3">
							<span class="font-bold mb-1">Working time</span>
							<input
								class="
									rounded-md
									peer
									pl-12
									pr-2
									py-2
									border-2 border-gray-200
									placeholder-gray-300
								"
								type="date"
								name="card_number"
								v-model="this.newDateObj.selecteDate"
							/>
							<svg
								xmlns="http://www.w3.org/2000/svg"
								class="
									absolute
									bottom-0
									left-0
									-mb-0.5
									transform
									translate-x-1/2
									-translate-y-1/2
									text-black
									dark:text-white
									peer-placeholder-shown:text-gray-300
									h-6
									w-6
								"
								fill="none"
								viewBox="0 0 24 24"
								stroke="currentColor"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"
								/>
							</svg>
						</label>

						<label class="relative flex-1 flex flex-col my-3">
							<span class="font-bold mb-1">Start</span>
							<input
								class="
									rounded-md
									peer
									pl-12
									pr-2
									py-2
									border-2 border-gray-200
									placeholder-gray-300
								"
								type="time"
								name="expire_date"
								placeholder="00:00"
								v-model="this.newDateObj.startTime"
							/>
							<svg
								xmlns="http://www.w3.org/2000/svg"
								class="
									absolute
									bottom-0
									left-0
									-mb-0.5
									transform
									translate-x-1/2
									-translate-y-1/2
									text-black
									dark:text-white
									peer-placeholder-shown:text-gray-300
									h-6
									w-6
								"
								fill="none"
								viewBox="0 0 24 24"
								stroke="currentColor"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
								/>
							</svg>
						</label>

						<label class="relative flex-1 flex flex-col my-3">
							<span class="font-bold mb-1">End</span>
							<input
								class="
									rounded-md
									peer
									pl-12
									pr-2
									py-2
									border-2 border-gray-200
									placeholder-gray-300
								"
								type="time"
								name="expire_date"
								placeholder="00:00"
								v-model="this.newDateObj.endTime"
							/>
							<svg
								xmlns="http://www.w3.org/2000/svg"
								class="
									absolute
									bottom-0
									left-0
									-mb-0.5
									transform
									translate-x-1/2
									-translate-y-1/2
									text-black
									dark:text-white
									peer-placeholder-shown:text-gray-300
									h-6
									w-6
								"
								fill="none"
								viewBox="0 0 24 24"
								stroke="currentColor"
							>
								<path
									stroke-linecap="round"
									stroke-linejoin="round"
									stroke-width="2"
									d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"
								/>
							</svg>
						</label>
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

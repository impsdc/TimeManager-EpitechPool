<script>
	import workingTimesAction from "@/functions/workingTimesFunctions";
	import useNotificationFactory from "@/tools/Toast";

	export default {
		name: "WorkingTime",
		components: {},
		props: {
			userId: Number,
			update: Function,
		},
		setup() {
			return {
				notificationWarning: useNotificationFactory(
					"warning",
					"Attention",
					"Entre une date et des heures valides."
				),
				notificationSuccess: useNotificationFactory(
					"success",
					"Félicitations !",
					"Votre temps de travail a bien été ajouté."
				),
			};
		},
		data() {
			return {
				selecteDate: null,
				startTime: null,
				endTime: null,
			};
		},
		methods: {
			async createWorkingTime() {
				if (!this.selecteDate || !this.startTime || !this.endTime) {
					this.notificationWarning();
					return;
				}
				let startR = `${this.selecteDate} ${this.startTime}:00`;
				let endR = `${this.selecteDate} ${this.endTime}:00`;
				await workingTimesAction.createWorkingTime(
					this.userId,
					startR,
					endR
				);
				this.notificationSuccess();
				if (this.update) this.update();
			},
			updateWorkingTime() {},
			deleteWorkingTime() {},
		},
	};
</script>

<template>
	<div class="flex flex-wrap gap-3 w-full p-2">
		<label class="relative w-full flex flex-col">
			<span class="font-bold mb-3 mt-2">Working time</span>
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
				v-model="selecteDate"
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

		<label class="relative flex-1 flex flex-col">
			<span class="font-bold mb-3">Start</span>
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
				v-model="startTime"
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

		<label class="relative flex-1 flex flex-col">
			<span class="font-bold mb-3">End</span>
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
				v-model="endTime"
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

		<button
			class="
				relative
				w-full
				flex flex-col
				text-white
				bg-purple-500
				font-bold
				uppercase
				text-sm
				px-6
				py-3
				rounded
				outline-none
				focus:outline-none
			"
			type="button"
			v-on:click="createWorkingTime"
		>
			Valider
		</button>
	</div>
</template>

<style scoped></style>

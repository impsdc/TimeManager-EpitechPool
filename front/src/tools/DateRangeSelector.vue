<script>
	import moment from "moment";
	import useNotificationFactory from "@/tools/Toast";

	export default {
		name: "DateRangeSelectors",
		props: {
			callBack: Function,
		},
		setup() {
			return {
				notificationWarning: useNotificationFactory(
					"warning",
					"Attention",
					"Rentre une date valide."
				),
			};
		},
		data() {
			return {
				startDate: null,
				startTime: null,
				endDate: null,
				endTime: null,
			};
		},
		methods: {
			fetchDate() {
				if (
					!this.startDate ||
					!this.startTime ||
					!this.endDate ||
					!this.endTime
				) {
					this.notificationWarning();
					return;
				}

				let startD = moment(`${this.startDate} ${this.startTime}:00`);
				let endD = moment(`${this.endDate} ${this.endTime}:00`);
				if (startD > endD) {
					this.notificationWarning();
					return;
				}
				let dateRange = {
					start: startD.format("YYYY-MM-DD HH:mm:ss"),
					end: endD.format("YYYY-MM-DD HH:mm:ss"),
				};
				this.callBack(dateRange);
			},
		},
	};
</script>

<template>
	<div>
		<p class="font-bold mb-1">Date de début</p>
		<div class="flex flex-row">
			<input
				type="date"
				placeholder="00:00"
				v-model="startDate"
				class="
					block
					text-sm
					py-3
					px-4
					rounded-lg
					w-full
					border
					outline-none
				"
			/>
			<input
				type="time"
				placeholder="00:00"
				v-model="startTime"
				class="block text-sm py-3 px-4 rounded-lg border outline-none"
			/>
		</div>
		<p class="font-bold mt-3 mb-1">Date de fin</p>
		<div class="flex flex-row">
			<input
				type="date"
				placeholder="00:00"
				v-model="endDate"
				class="
					block
					text-sm
					py-3
					px-4
					rounded-lg
					w-full
					border
					outline-none
				"
			/>
			<input
				type="time"
				placeholder="00:00"
				v-model="endTime"
				class="block text-sm py-3 px-4 rounded-lg border outline-none"
			/>
		</div>
		<button
			class="
				text-purple-500
				bg-transparent
				border border-solid border-purple-500
				hover:bg-purple-500 hover:text-white
				active:bg-purple-600
				font-bold
				uppercase
				text-sm
				px-6
				py-3
				rounded
				outline-none
				focus:outline-none
				mb-0
				ease-linear
				transition-all
				duration-150
				mt-3
				justify-self-end
			"
			type="button"
			v-on:click="fetchDate"
		>
			Valider
		</button>
	</div>
</template>

<style></style>

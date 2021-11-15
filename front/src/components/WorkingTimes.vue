<script>
	import axios from "axios";
	import moment from "moment";
	import Tableau from "../tools/Tableau.vue";
	import LineChart from "@/tools/charts/LineChart.vue";
	import workingTimesAction from "@/functions/workingTimesFunctions";
	import { useStorage } from "@vueuse/core";
	import dateActions from "@/functions/dateFunctions";
	import ModalW from "../tools/ModalW.vue";

	export default {
		name: "WorkingTimes",
		components: {
			Tableau,
			LineChart,
			ModalW,
		},
		props: {
			id: Number,
			data: Array,
			update: Function,
		},
		data() {
			return {
				user: null,
				dates: null,
				showModal: false,
				selectedWT: null,
			};
		},
		mounted() {
			this.user = useStorage("user");
			if (this.data) this.dates = this.data;
		},
		watch: {
			data: function () {
				this.dates = this.data;
			},
		},
		methods: {
			async deleteWorkingTime(id) {
				await workingTimesAction.deleteWorkingTime(id);
				if (this.update) this.update();
			},
			async updateWorkingTime(workingTimeID, start, end) {
				let response = await workingTimesAction.updateWorkingTime(
					this.id,
					workingTimeID,
					start,
					end
				);
				return response;
			},

			selectUserID(id) {
				this.selectedWT = null;
				if (id) {
					let index = this.dates.findIndex((it) => it.id === id);
					this.selectedWT = this.dates[index];
				}
				this.toggleModal();
			},
			toggleModal() {
				this.showModal = !this.showModal;
			},
		},
	};
</script>

<template>
	<div>
		<Tableau
			:titles="['ID', 'Start', 'End']"
			:items="['id', 'start', 'end']"
			:lines="dates"
			:edit="selectUserID"
			:remove="deleteWorkingTime"
		/>
		<ModalW
			v-if="showModal"
			:edit="updateWorkingTime"
			:dateObj="selectedWT"
			:toggleModal="toggleModal"
			:refresh="update"
		/>
	</div>
</template>

<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
	h1,
	h2 {
		font-weight: normal;
	}
	ul {
		list-style-type: none;
		padding: 0;
	}
	li {
		display: inline-block;
		margin: 0 10px;
	}
	a {
		color: #42b983;
	}
</style>

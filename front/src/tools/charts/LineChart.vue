<script>
	import { Line } from "vue3-chart-v2";

	export default {
		name: "LineChart",
		extends: Line,
		props: {
			workingtimes: {
				type: Object,
				default: null,
			},
			color: {
				type: String,
				default: null,
			},
		},
		data() {
			return {
				options: {
					responsive: true,
					maintainAspectRatio: false,
					title: {
						display: true,
						text: "Temps de présence",
					},
				},
				chartdata: {
					labels: [],
					datasets: [
						{
							label: "Heure de présence",
							data: [],
							backgroundColor: this.color
								? this.color
								: "#7D3AED",
						},
					],
				},
				workingtimeCopy: [],
			};
		},
		methods: {
			lineRender(workingtimes) {
				let fkingChart = { ...this.chartdata };
				fkingChart.labels = workingtimes.labels;
				fkingChart.datasets = [
					{
						label: "Heure de présence",
						backgroundColor: this.color ? this.color : "#7D3AED",
						data: workingtimes.datasetsData,
					},
				];
				this.renderChart(fkingChart, this.options);
			},
		},
		watch: {
			workingtimes: function (newWorkingTimes) {
				if (
					!newWorkingTimes ||
					!newWorkingTimes.labels ||
					!newWorkingTimes.datasetsData
				)
					return;
				this.workingtimeCopy = newWorkingTimes;
				this.lineRender(this.workingtimeCopy);
			},
		},
		mounted() {
			if (
				!this.workingtimeCopy ||
				!this.workingtimeCopy.labels ||
				!this.workingtimeCopy.datasetsData
			)
				return;
			this.workingtimeCopy = this.workingtimes;
			this.lineRender(this.workingtimeCopy);
		},
	};
</script>

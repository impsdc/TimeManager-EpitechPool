<script>
	import useNotificationFactory from "@/tools/Toast";
	import TeamsActions from "@/functions/teamsFunctions";
	import globalActions from "@/functions/globalFunctions";
	import UserActions from "@/functions/usersFunctions";

	const modeConfig = {
		Teams: {
			dataKey: "name",
			functionName: TeamsActions.getAllTeams,
		},
		TeamsUsers: {
			dataKey: "username",
			functionName: TeamsActions.getAllTeamUsers,
		},
		Users: {
			dataKey: "username",
			functionName: UserActions.getAllUsers,
		},
	};

	export default {
		name: "TeamSelector",
		props: {
			user: Object,
			mode: String,
			callBack: Function,
		},
		setup() {
			return {
				notificationWarning: useNotificationFactory(
					"warning",
					"Attention",
					"Selectionner au moins un élément."
				),
				modeConfig,
			};
		},
		data() {
			return {
				data: [],
				selected: [],
			};
		},
		async mounted() {
			await this.initData();
		},
		watch: {
			mode: async function () {
				await this.initData();
			},
		},
		methods: {
			async initData() {
				let response = await this.modeConfig[this.mode].functionName(
					this.user.team
				);
				let usersList = response.data.data;
				if (this.mode === "Users" || this.mode === "TeamsUsers") {
					usersList = globalActions.listCleaner(
						"id",
						this.user.id,
						usersList
					);
				}
				if (this.mode === "TeamsUsers") {
					usersList = usersList.filter(
						(it) => it.role === 0 || it.role === 1
					);
					console.log("clearrr");
				}
				console.log(usersList);
				this.data = usersList;
			},
			async fetchData() {
				if (this.selected.length > 0) {
					let res = this.selected;
					if (this.mode === "Teams")
						res = await TeamsActions.getUsersOfTeams(this.selected);
					this.callBack(res);
				}
			},
			selectOption(option) {
				console.log("option=>", option);
			},
		},
	};
</script>

<template>
	<div>
		<p class="font-bold mb-1">Teams</p>
		<div class="flex flex-col content-center">
			<select
				v-if="data"
				v-model="selected"
				@change="selectOption($event.target.value)"
				multiple
			>
				<option v-for="item in data" v-bind:value="item" :key="item">
					{{ item.id }} -
					{{ item[this.modeConfig[this.mode].dataKey] }}
				</option>
			</select>
			<span>Vous avez sélectionné(s) : </span>
			<span
				v-for="item in selected"
				v-bind:value="item.id"
				:key="item"
				class="flex-row"
			>
				{{ item[this.modeConfig[this.mode].dataKey] }}
			</span>
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
			v-on:click="fetchData"
		>
			Valider
		</button>
	</div>
</template>

<style></style>

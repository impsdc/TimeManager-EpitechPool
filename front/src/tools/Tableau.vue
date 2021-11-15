<script>
	import moment from "moment";
	import UserActions from "@/functions/usersFunctions";
	import TeamsActions from "@/functions/teamsFunctions";

	export default {
		name: "Tableau",
		props: {
			titles: Array,
			items: Array,
			lines: Array,
			see: Function,
			edit: Function,
			remove: Function,
			user: Object,
		},
		data() {
			return {
				allTeam: null,
			};
		},
		async mounted() {
			if (this.items.indexOf("team") !== -1) {
				console.log("ezzlijorjoizreozr", this.user);
				if (this.user && this.user.role === 2) {
					let reponse = await TeamsActions.getAllTeams();
					this.allTeam = [...reponse.data.data];
				}
				if (this.user && this.user.role === 1) {
					let reponse = await TeamsActions.getTeam(this.user.team);
					this.allTeam = [{ ...reponse.data.data }];
				}
			}
		},
		computed: {
			tabFormater() {
				return (key, value) => {
					if (key === "team" && this.allTeam) {
						let index = this.allTeam.findIndex(
							(it) => it.id === value
						);
						return `${this.allTeam[index].name}`;
					}
					if (key === "role")
						return `${UserActions.roleOfUser[value]}`;
					if (key === "start" || key === "end")
						return `${moment(value).format("DD MMM YY HH:mm")}`;
					else return `${value}`;
				};
			},
		},
	};
</script>

<template>
	<div class="bg-white shadow-md rounded my-6 block w-full overflow-x-auto">
		<table class="min-w-max w-full table-auto">
			<thead>
				<tr
					class="
						bg-gray-200
						text-gray-600
						uppercase
						text-sm
						leading-normal
					"
				>
					<th
						class="py-3 px-6 text-left"
						v-for="item in titles"
						:key="item"
					>
						{{ item }}
					</th>
					<th v-if="edit || remove" class="py-3 px-6 text-left">
						Actions
					</th>
				</tr>
			</thead>
			<tbody>
				<tr v-for="item in lines" v-bind:key="item">
					<td
						v-for="it in items"
						:key="it"
						class="
							border-t-0
							px-6
							align-middle
							border-l-0 border-r-0
							text-xs
							whitespace-nowrap
							p-4
						"
					>
						{{ tabFormater(it, item[it]) }}
					</td>
					<td
						v-if="edit || remove"
						class="
							border-t-0
							px-6
							align-middle
							border-l-0 border-r-0
							text-xs
							whitespace-nowrap
							p-4
						"
					>
						<div class="flex">
							<div
								v-if="see"
								v-on:click="see(item.id)"
								class="
									w-4
									mr-2
									transform
									hover:text-purple-500 hover:scale-110
								"
							>
								<svg
									xmlns="http://www.w3.org/2000/svg"
									className="h-6 w-6"
									fill="none"
									viewBox="0 0 24 24"
									stroke="currentColor"
								>
									<path
										strokeLinecap="round"
										strokeLinejoin="round"
										strokeWidth="{2}"
										d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
									/>
									<path
										strokeLinecap="round"
										strokeLinejoin="round"
										strokeWidth="{2}"
										d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"
									/>
								</svg>
							</div>
							<div
								v-if="edit"
								v-on:click="edit(item.id)"
								class="
									w-4
									mr-2
									transform
									hover:text-purple-500 hover:scale-110
								"
							>
								<svg
									xmlns="http://www.w3.org/2000/svg"
									fill="none"
									viewBox="0 0 24 24"
									stroke="currentColor"
								>
									<path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="2"
										d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"
									/>
								</svg>
							</div>
							<div
								v-if="remove"
								v-on:click="remove(item.id)"
								class="
									w-4
									mr-2
									transform
									hover:text-purple-500 hover:scale-110
								"
							>
								<svg
									xmlns="http://www.w3.org/2000/svg"
									fill="none"
									viewBox="0 0 24 24"
									stroke="currentColor"
								>
									<path
										stroke-linecap="round"
										stroke-linejoin="round"
										stroke-width="2"
										d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
									/>
								</svg>
							</div>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</div>
</template>

<style scoped></style>

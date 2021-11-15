<script>
	import { useRouter, useRoute } from "vue-router";
	import { ref } from "vue";
	import ClockManager from "@/components/ClockManager.vue";
	import User from "@/components/User.vue";
	import WorkingTimes from "@/components/WorkingTimes.vue";
	// import userAction from "@/functions/users";
	import WorkingTime from "@/components/WorkingTime.vue";
	import Storage from "@/functions/storageFunctions";
	import roleConfig from "@/configs/roleConfig";
	import TabBar from "@/router/navbar/TabBar";
	import NavBar from "@/router/navbar/NavBar";

	export default {
		name: "Home",
		components: {
			ClockManager,
			User,
			WorkingTimes,
			WorkingTime,
			TabBar,
			NavBar,
		},
		data: function () {
			return {
				active: true,
			};
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
			};
		},
		methods: {
			logoutFuntion() {
				Storage.remove("user");
				this.$router.push(`/login`);
			},
			isChecked() {
				active = !active;
			},
		},
	};
</script>

<template>
	<div id="theme" class="" :class="[active ? '' : 'dark']">
		<main
			class="
				bg-gray-100
				dark:bg-gray-800
				h-screen
				overflow-hidden
				relative
			"
		>
			<div class="flex items-start">
				<!--- NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar NavBar-->
				<TabBar />
				<!--- Content Content Content Content Content Content Content Content Content Content Content Content Content Content Content-->
				<div class="items-start justify-between w-full">
					<router-view />
					<NavBar />
				</div>
			</div>
		</main>
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
</style>

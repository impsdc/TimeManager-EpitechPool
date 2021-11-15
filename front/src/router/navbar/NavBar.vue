<script>
	import { useRouter, useRoute } from "vue-router";
	import { ref } from "vue";
	import Storage from "@/functions/storageFunctions";
	import roleConfig from "@/configs/roleConfig";
	import useNotificationFactory from "@/tools/Toast";
	import navigation from "@/router/navbar/navigation";
	import axios from "../../tools/axios";

	export default {
		name: "TabBar",
		components: {},

		setup() {
			const router = useRouter();
			const route = useRoute();
			const ROLEConfig = roleConfig;

			const currentRoute = ref(router.currentRoute._value.name);
			let user = Storage.get("user");

			return {
				currentRoute,
				user,
				ROLEConfig,
				navigation,

				notificationSuccess: useNotificationFactory(
					"success",
					"Vous avez bien été déconnectée"
				),
				notificationRedirect: useNotificationFactory(
					"error",
					"Vous devez vous connecter avant d'accéder à cette ressource"
				),
			};
		},
		data() {
			return {
				user: Storage.get("user"),
			};
		},
		beforeMount() {
			if (this.user === null) {
				this.notificationRedirect();
				this.$router.push(`/login`);
				setTimeout(() => {
					location.reload();
				}, 1000);
			}
		},
		mounted() {
			this.navigation = this.navigation.filter(
				(it) => it.mobileAvailable == true
			);
		},
		methods: {
			async logoutFuntion() {
				await axios.get("/logout").then((response) => {
					this.notificationSuccess();
				});
				this.$router.push(`/login`);
				Storage.remove("user");
			},
			isChecked() {
				active = !active;
			},
		},
	};
</script>

<template>
	<div class="lg:invisible relative z-50">
		<div class="min-h-screen bg-white-500 p-5 text-white-800">
			<!-- fixed nav -->
			<nav
				class="
					fixed
					bottom-0
					inset-x-0
					bg-purple-100
					border-2 border-grey
					flex
					justify-around
					text-sm text-white-900
					uppercase
					font-mono
				"
			>
				<router-link
					to="/dashboard"
					class="
						w-full
						block
						py-2
						px-2
						text-center
						hover:bg-purple-200 hover:text-purple-800
					"
					v-on:click="this.$router.push('/dashboard')"
				>
					<svg
						class="w-6 h-6 mb-2 mx-auto"
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
					>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
						/>
					</svg>
					Dashboard
				</router-link>
				<router-link
					v-if="user.role === 1 || user.role === 2"
					to="/dashboardAdmin"
					class="
						w-full
						block
						py-2
						px-2
						text-center
						hover:bg-purple-200 hover:text-purple-800
					"
					v-on:click="this.$router.push('/dashboardAdmin')"
				>
					<svg
						class="w-6 h-6 mb-2 mx-auto"
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
					>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
						/>
					</svg>
					Dashboard Admin
				</router-link>
				<router-link
					to="/settings"
					class="
						w-full
						block
						py-2
						px-2
						text-center
						hover:bg-purple-200 hover:text-purple-800
					"
					v-on:click="this.$router.push('/settings')"
				>
					<svg
						class="w-6 h-6 mb-2 mx-auto"
						xmlns="http://www.w3.org/2000/svg"
						fill="none"
						viewBox="0 0 24 24"
						stroke="currentColor"
					>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
						/>
						<path
							stroke-linecap="round"
							stroke-linejoin="round"
							stroke-width="2"
							d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
						/>
					</svg>
					Settings
				</router-link>
			</nav>
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
</style>

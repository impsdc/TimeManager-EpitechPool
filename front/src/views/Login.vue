<script>
	import LoginAccount from "@/components/LoginAccount.vue";
	// import RegisterAccount from "@/components/RegisterAccount.vue";

	export default {
		name: "Login",
		components: {
			LoginAccount,
			// RegisterAccount,
		},
		data() {
			return {};
		},
	};
</script>

<template>
	<LoginAccount />
	<!-- <RegisterAccount v-else /> -->
</template>

<style></style>

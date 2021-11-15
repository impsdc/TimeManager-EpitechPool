<script>
	import { NNotificationProvider } from "naive-ui";
	export default {
		name: "App",
		components: {
			NNotificationProvider,
		},
		mounted() {},
		methods: {},
	};
</script>

<template>
	<n-notification-provider>
		<router-view />
	</n-notification-provider>
</template>

<style></style>

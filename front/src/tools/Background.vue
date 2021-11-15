<script>
	export default {
		name: "Background",
		props: {
			content: Function,
		},
		components: {},
	};
</script>

<template>
	<div
		class="
			min-h-screen
			bg-gray-100
			py-6
			flex flex-col
			justify-center
			sm:py-12
		"
	>
		<div class="relative py-3 sm:max-w-xl sm:mx-auto">
			<div
				class="
					absolute
					inset-0
					bg-gradient-to-r
					from-purple-300
					to-purple-600
					shadow-lg
					transform
					-skew-y-6
					sm:skew-y-0 sm:-rotate-6 sm:rounded-3xl
				"
			></div>
		</div>
	</div>
	<div
		class="
			absolute
			w-60
			h-60
			rounded-xl
			bg-purple-300
			-top-5
			-left-16
			z-0
			transform
			rotate-45
			hidden
			md:block
		"
	></div>
	<div
		class="
			absolute
			w-20
			h-20
			rounded-xl
			bg-purple-300
			bottom-0
			-right-0
			hidden
			md:block
		"
	></div>
	<div
		class="
			w-40
			h-40
			absolute
			bg-purple-300
			rounded-full
			top-0
			right-12
			hidden
			md:block
		"
	></div>
	<div
		class="
			w-20
			h-40
			absolute
			bg-purple-300
			rounded-full
			bottom-10
			left-10
			transform
			rotate-45
			hidden
			md:block
		"
	></div>
</template>

<style></style>

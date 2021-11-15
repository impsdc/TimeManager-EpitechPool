<script>
	export default {
		props: {
			options: {
				type: Array,
				required: true,
			},
			default: {
				type: String,
				required: false,
				default: null,
			},
			tabindex: {
				type: Number,
				required: false,
				default: 0,
			},
		},
		data() {
			return {
				selected: this.default
					? this.default
					: this.options.length > 0
					? this.options[0]
					: null,
				open: false,
			};
		},
		mounted() {
			this.$emit("input", this.selected);
		},
	};
</script>

<template>
	<div class="custom-select" :tabindex="tabindex" @blur="open = false">
		<div class="selected" :class="{ open: open }" @click="open = !open">
			<svg
				width="20"
				height="20"
				fill="currentColor"
				class="mr-2 text-gray-400"
				viewBox="0 0 1792 1792"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					d="M192 1664h288v-288h-288v288zm352 0h320v-288h-320v288zm-352-352h288v-320h-288v320zm352 0h320v-320h-320v320zm-352-384h288v-288h-288v288zm736 736h320v-288h-320v288zm-384-736h320v-288h-320v288zm768 736h288v-288h-288v288zm-384-352h320v-320h-320v320zm-352-864v-288q0-13-9.5-22.5t-22.5-9.5h-64q-13 0-22.5 9.5t-9.5 22.5v288q0 13 9.5 22.5t22.5 9.5h64q13 0 22.5-9.5t9.5-22.5zm736 864h288v-320h-288v320zm-384-384h320v-288h-320v288zm384 0h288v-288h-288v288zm32-480v-288q0-13-9.5-22.5t-22.5-9.5h-64q-13 0-22.5 9.5t-9.5 22.5v288q0 13 9.5 22.5t22.5 9.5h64q13 0 22.5-9.5t9.5-22.5zm384-64v1280q0 52-38 90t-90 38h-1408q-52 0-90-38t-38-90v-1280q0-52 38-90t90-38h128v-96q0-66 47-113t113-47h64q66 0 113 47t47 113v96h384v-96q0-66 47-113t113-47h64q66 0 113 47t47 113v96h128q52 0 90 38t38 90z"
				></path>
			</svg>
			{{ selected }}
			<svg
				width="20"
				height="20"
				class="ml-2 text-gray-400"
				fill="currentColor"
				viewBox="0 0 1792 1792"
				xmlns="http://www.w3.org/2000/svg"
			>
				<path
					d="M1408 704q0 26-19 45l-448 448q-19 19-45 19t-45-19l-448-448q-19-19-19-45t19-45 45-19h896q26 0 45 19t19 45z"
				></path>
			</svg>
		</div>
		<div class="items" :class="{ selectHide: !open }">
			<div
				v-for="(option, i) of options"
				:key="i"
				@click="
					selected = option;
					open = false;
					$emit('input', option);
				"
			>
				{{ option }}
			</div>
		</div>
	</div>
</template>

<style scoped>
	.custom-select {
		position: relative;
		width: 100%;
		text-align: left;
		outline: none;
		height: 47px;
		line-height: 47px;
	}

	.custom-select .selected {
		background-color: #0a0a0a;
		border-radius: 6px;
		border: 1px solid #666666;
		color: #fff;
		padding-left: 1em;
		cursor: pointer;
		user-select: none;
		flex-direction: row;
	}

	.custom-select .selected.open {
		border: 1px solid #ad8225;
		border-radius: 6px 6px 0px 0px;
	}

	.custom-select .selected:after {
		position: absolute;
		content: "";
		top: 22px;
		right: 1em;
		width: 0;
		height: 0;
		border: 5px solid transparent;
		border-color: #fff transparent transparent transparent;
	}

	.custom-select .items {
		color: #fff;
		border-radius: 0px 0px 6px 6px;
		overflow: hidden;
		border-right: 1px solid #ad8225;
		border-left: 1px solid #ad8225;
		border-bottom: 1px solid #ad8225;
		position: absolute;
		background-color: #0a0a0a;
		left: 0;
		right: 0;
		z-index: 1;
	}

	.custom-select .items div {
		color: #fff;
		padding-left: 1em;
		cursor: pointer;
		user-select: none;
	}

	.custom-select .items div:hover {
		background-color: #ad8225;
	}

	.selectHide {
		display: none;
	}
</style>

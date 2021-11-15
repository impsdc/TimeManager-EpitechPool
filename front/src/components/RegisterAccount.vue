<script>
	import userAction from "@/functions/usersFunctions";

	export default {
		name: "RegisterAccount",
		props: {
			changeMode: Function,
		},
		data() {
			return {
				username: null,
				email: null,
				password: null,
				role: null,
				team: null,
				isSignUP: false,
			};
		},
		methods: {
			async submitRequest() {
				console.log(this.username, this.email, this.role, this.team);
				let response = await await userAction.createUser(
					this.email,
					this.username,
					this.role,
					this.team
				);
				console.log("response=>", response);
				if (response.data.data !== null || !response.data.data.id)
					this.$router.push(`/workingTimes/${response.data.data.id}`);
			},
		},
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
		<div class="container mx-auto">
			<div class="flex justify-center px-6 my-12">
				<!-- Row -->
				<div class="w-full xl:w-3/4 lg:w-11/12 flex" id="register">
					<!-- Col -->
					<div
						class="
							w-full
							h-auto
							bg-purple-400
							hidden
							lg:block lg:w-5/12
							bg-cover
							rounded-l-lg
						"
						style="
							background-image: url('https://zupimages.net/up/21/43/vhoi.jpg');
						"
					></div>
					<!-- Col -->
					<div
						class="
							w-full
							lg:w-7/12
							bg-white
							p-5
							rounded-lg
							lg:rounded-l-none
						"
					>
						<h3 class="pt-4 text-2xl text-center">
							Create an Account !
						</h3>
						<form class="px-8 pt-6 pb-8 mb-4 bg-white rounded">
							<div class="mb-4 md:flex md:justify-between">
								<div class="mb-4 md:mr-2 md:mb-0">
									<label
										class="
											block
											mb-2
											text-sm
											font-bold
											text-gray-700
										"
										for="Username"
									>
										Username
									</label>
									<input
										class="
											w-full
											px-3
											py-2
											text-sm
											leading-tight
											text-gray-700
											border
											rounded
											shadow
											appearance-none
											focus:outline-none
											focus:shadow-outline
										"
										v-model="username"
										id="username"
										type="text"
										placeholder="Username"
									/>
								</div>
								<div class="md:ml-2">
									<label
										class="
											block
											mb-2
											text-sm
											font-bold
											text-gray-700
										"
										for="Role"
									>
										Role
									</label>
									<input
										class="
											w-full
											px-3
											py-2
											text-sm
											leading-tight
											text-gray-700
											border
											rounded
											shadow
											appearance-none
											focus:outline-none
											focus:shadow-outline
										"
										v-model="role"
										id="role"
										type="text"
										placeholder="Role"
									/>
								</div>
								<div class="md:ml-2">
									<label
										class="
											block
											mb-2
											text-sm
											font-bold
											text-gray-700
										"
										for="Team"
									>
										Team
									</label>
									<input
										class="
											w-full
											px-3
											py-2
											text-sm
											leading-tight
											text-gray-700
											border
											rounded
											shadow
											appearance-none
											focus:outline-none
											focus:shadow-outline
										"
										v-model="team"
										id="team"
										type="text"
										placeholder="Team"
									/>
								</div>
							</div>
							<div class="mb-4">
								<label
									class="
										block
										mb-2
										text-sm
										font-bold
										text-gray-700
									"
									for="email"
								>
									Email
								</label>
								<input
									class="
										w-full
										px-3
										py-2
										mb-3
										text-sm
										leading-tight
										text-gray-700
										border
										rounded
										shadow
										appearance-none
										focus:outline-none focus:shadow-outline
									"
									v-model="email"
									id="email"
									type="email"
									placeholder="Email"
								/>
							</div>
							<div class="mb-4 md:flex md:justify-between">
								<div class="mb-4 md:mr-2 md:mb-0">
									<label
										class="
											block
											mb-2
											text-sm
											font-bold
											text-gray-700
										"
										for="password"
									>
										Password
									</label>
									<input
										class="
											w-full
											px-3
											py-2
											mb-3
											text-sm
											leading-tight
											text-gray-700
											border border-red-500
											rounded
											shadow
											appearance-none
											focus:outline-none
											focus:shadow-outline
										"
										id="password"
										type="password"
										placeholder="******************"
									/>
									<p class="text-xs italic text-red-500">
										Please choose a password.
									</p>
								</div>
								<div class="md:ml-2">
									<label
										class="
											block
											mb-2
											text-sm
											font-bold
											text-gray-700
										"
										for="c_password"
									>
										Confirm Password
									</label>
									<input
										class="
											w-full
											px-3
											py-2
											mb-3
											text-sm
											leading-tight
											text-gray-700
											border
											rounded
											shadow
											appearance-none
											focus:outline-none
											focus:shadow-outline
										"
										id="c_password"
										type="password"
										placeholder="******************"
									/>
								</div>
							</div>
							<div class="mb-6 text-center">
								<button
									class="
										w-full
										px-4
										py-2
										font-bold
										text-white
										bg-purple-500
										rounded-md
										hover:bg-purple-700
										focus:outline-none focus:shadow-outline
									"
									type="button"
									v-on:click="submitRequest"
								>
									Register Account
								</button>
							</div>
							<hr class="mb-6 border-t" />
							<div class="text-center">
								<p class="text-sm">
									Already Have An Account?
									<span
										v-on:click="changeMode()"
										class="underline cursor-pointer"
										>Login</span
									>
								</p>
							</div>
						</form>
					</div>
				</div>
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
	</div>
</template>

<style scoped>
	#register {
		border-radius: 20px;
		box-shadow: 10px 5px 5px gray;
	}
</style>

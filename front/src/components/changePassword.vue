<template>
	<div
		class="
			my-4
			shadow-lg
			px-4
			py-6
			w-full
			bg-white
			dark:bg-gray-700
			relative
			rounded-2xl
		"
	>
		<div class="flex items-center">
			<span class="rounded-xl relative p-2 bg-purple-100">
				<svg
					class="h-8 w-8 text-purple-600 ml-1"
					fill="none"
					viewBox="0 0 24 24"
					stroke="currentColor"
				>
					<path
						stroke-linecap="round"
						stroke-linejoin="round"
						stroke-width="2"
						d="M12.075,10.812c1.358-0.853,2.242-2.507,2.242-4.037c0-2.181-1.795-4.618-4.198-4.618S5.921,4.594,5.921,6.775c0,1.53,0.884,3.185,2.242,4.037c-3.222,0.865-5.6,3.807-5.6,7.298c0,0.23,0.189,0.42,0.42,0.42h14.273c0.23,0,0.42-0.189,0.42-0.42C17.676,14.619,15.297,11.677,12.075,10.812 M6.761,6.775c0-2.162,1.773-3.778,3.358-3.778s3.359,1.616,3.359,3.778c0,2.162-1.774,3.778-3.359,3.778S6.761,8.937,6.761,6.775 M3.415,17.69c0.218-3.51,3.142-6.297,6.704-6.297c3.562,0,6.486,2.787,6.705,6.297H3.415z"
					></path>
				</svg>
			</span>
			<div class="flex flex-col">
				<span class="font-bold text-md text-black dark:text-white ml-2"
					>User settings</span
				>
				<span class="text-sm text-gray-500 dark:text-white ml-2"
					>Change password</span
				>
			</div>
		</div>
		<div class="py-4">
			<p class="text-md text-gray-500 dark:text-white ml-2">
				Votre nouveau mot de passe doit faire au minimun 8 caractères et
				contenir au moins :<br />
				<strong>1</strong> Majuscule<br />
				<strong>1</strong> Chiffre<br />
				<strong>1</strong> Caractère spéciale<br />
			</p>
		</div>
		<div class="pt-6 pb-6 mb-4 bg-white rounded">
			<label
				class="block mb-2 text-sm font-bold text-gray-700"
				for="currentPassword"
			>
				Mot de passe actuel
			</label>
			<input
				id="currentPassword"
				v-model="password"
				type="password"
				class="
					w-1/3
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
			/>
			<div class="flex w-full align-center">
				<div class="w-1/3">
					<label
						class="block mb-2 text-sm font-bold text-gray-700"
						for="newpassword"
					>
						Nouveau Mot de passe
					</label>
					<input
						id="newpassword"
						@input="checkingPassword"
						v-model="newPassword"
						autocomplete="true"
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
						:class="[wrongPassword ? 'border-red-500 ' : '']"
						type="password"
					/>
				</div>
				<div class="w-1/3 pl-10">
					<label
						class="block mb-2 text-sm font-bold text-gray-700"
						for="confirmpassword"
					>
						Confirmer Mot de passe
					</label>
					<input
						id="confirmpassword"
						autocomplete="true"
						@input="checkingPasswordConfirm"
						v-model="newPasswordConfirm"
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
						:class="[wrongPasswordconfirm ? 'border-red-500 ' : '']"
						type="password"
					/>
					<p
						v-if="wrongPasswordconfirm"
						class="text-red-500 text-xs italic"
					>
						Les mots de passe ne correspondes pas !
					</p>
				</div>
			</div>
			<p v-if="errorQuery" class="p-2 text-red-500 text-xs italic">
				Le mot de passe de correspond pas au critère
			</p>
			<button
				@click="handleClick"
				class="
					text-white
					font-bold
					py-2
					px-4
					rounded
					bg-purple-500
					hover:bg-purple-700
					mt-5
				"
			>
				<span>Changer de mot de passe</span>
			</button>
		</div>
	</div>
</template>

<script>
	import useNotificationFactory from "@/tools/Toast";
	import axios from "../tools/axios";

	export default {
		name: "ChangePassword",
		props: {
			id: {
				type: Number,
			},
		},
		setup() {
			return {
				notificationError: useNotificationFactory(
					"error",
					"Attention",
					"Votre mot de passe actuel n'est pas valide ... "
				),
				notificationNotFound: useNotificationFactory(
					"error",
					"Attention",
					"Votre requête n'a pas abouti"
				),
				notificationUnauthorized: useNotificationFactory(
					"error",
					"Attention",
					"Vous n'avez pas le role adéquat pour faire cette requête"
				),

				notificationSuccess: useNotificationFactory(
					"success",
					"Mot de passe mis à jour"
				),
			};
		},
		data() {
			return {
				password: "",
				newPassword: "",
				newPasswordConfirm: "",
				reg: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
				wrongPassword: false,
				wrongPasswordconfirm: false,
				errorQuery: false,
				test: "Santamaria@56",
			};
		},
		methods: {
			checkingPassword: function () {
				setTimeout(() => {
					if (this.newPassword.match(this.reg)) {
						this.wrongPassword = false;
					} else {
						this.wrongPassword = true;
					}
				}, 800);
			},
			checkingPasswordConfirm: function () {
				setTimeout(() => {
					if (this.newPassword === this.newPasswordConfirm) {
						this.wrongPasswordconfirm = false;
					} else {
						this.wrongPasswordconfirm = true;
					}
				}, 800);
			},
			handleClick: async function () {
				if (
					!this.wrongPassword &&
					!this.wrongPasswordconfirm &&
					this.newPassword != ""
				) {
					await axios
						.post(
							`/changepassword/${this.id}`,
							{
								password: this.password,
								newpassword: this.newPassword,
							},
							{ withCredentials: true }
						)
						.then((response) => {
							if (response.status === 200) {
								this.notificationSuccess();
							} else if (response.includes("password")) {
								this.notificationError();
							} else if (response.includes("right")) {
								this.notificationUnauthorized();
							}
						})
						.catch((err) => {
							this.notificationNotFound();
						});
				} else {
					this.errorQuery = true;
				}
			},
		},
	};
</script>

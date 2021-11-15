<script>
import userAction from "@/functions/usersFunctions";
import Storage from "@/functions/storageFunctions";
import useNotificationFactory from "@/tools/Toast";

export default {
  name: "LoginAccount",

  setup() {
    return {
      notificationWarning: useNotificationFactory(
        "warning",
        "Attention",
        "Veuillez entrer un password ou un email valide."
      ),

      notificationSuccess: useNotificationFactory(
        "success",
        "Félicitations !",
        "Connexion réussie, vous êtes maintenant connecté."
      ),
      email: null,
      password: null,
    };
  },
  data() {
	  return{
		  error:false
	  }
  },

  methods: {
    async submitRequest() {
      if (!this.email || !this.password) {
        this.notificationWarning();
        return;
      }

      let response = await userAction.loginUser({
        email: this.email,
        password: this.password,
      });
      console.log("response=>", response);
	  console.log(typeof(response))
	  if(typeof(response) === 'string'){
		  console.log('in')
		  this.error = true
	  }else{
		   Storage.set(
          "user",
          JSON.stringify({
            ...response.data.data,
            roleTitle: userAction.roleOfUser[response.data.data.role],
          })
        );
        this.notificationSuccess();
        this.$router.push(`/dashboard`);

        console.log(Storage.get("user"));
	  }
    },
    changeScreen() {
      this.changeMode();
    },
    cacherDiv() {
      document.getElementById("div_a_cacher").style.visibility = "hidden";
    },
  },
};
</script>

<template>
  <div
    class="bg-no-repeat bg-cover bg-center relative"
    style="background-image: url(https://zupimages.net/up/21/45/ufca.jpg)"
  >
    <div
      class="
        absolute
        bg-gradient-to-b
        from-purple-500
        to-purple-400
        opacity-75
        inset-0
        z-0
      "
    ></div>
    <div
      class="min-h-screen sm:flex sm:flex-row mx-0 justify-center rounded-3xl"
    >
      <div
        class="
          flex-col flex
          self-center
          p-10
          sm:max-w-5xl
          xl:max-w-2xl
          z-10
          rounded-3xl
        "
      >
        <div class="self-start hidden lg:flex flex-col text-white">
          <img src="" class="mb-3" />
          <h1 class="mb-2 font-bold text-4xl">
            Hi 👋 Bienvenue sur TimeManager
          </h1>
          <p class="mb-2 pr-3">
            Pour accéder à l'application, merci de vous connecter ! <br />
            Pour toutes informations supplémentaires, n'hésiter pas à consulter
            notre FAQ.
          </p>
        </div>
      </div>
      <div class="flex justify-center self-center z-10 rounded-3xl">
        <div class="relative py-3 sm:max-w-xl sm:mx-auto rounded-3xl">
          <div
            class="
              relative
              px-4
              py-10
              bg-white
              shadow-lg
              sm:p-20
              rounded-3xl
              mr-5
            "
          >
            <div class="max-w-md mx-auto">
              <div>
                <h1 class="text-2xl font-semibold">Login</h1>
              </div>
              <div class="divide-y divide-gray-200">
                <div
                  class="
				  pt-5
                    leading-6
                    space-y-4
                    text-gray-700
                    sm:text-lg sm:leading-7
                  "
                >
                  <div class="relative">
                    <input
                      id="email"
                      type="email"
                      placeholder="Email"
                      v-model="email"
					  required
                      class="
                        block
                        text-sm
                        py-3
                        px-4
                        rounded-lg
                        w-full
                        border
                        outline-none
                      "
                    />
                  </div>
                  <div class="relative">
                    <input
                      id="password"
                      type="password"
                      placeholder="Password"
                      v-model="password"
					  required
                      class="
                        block
                        text-sm
                        py-3
                        px-4
                        rounded-lg
                        w-full
                        border
                        outline-none
                      "
                    />
                  </div>
                  <div class="relative text-center">
                    <button
                      class="
                        bg-purple-500
                        w-full
                        text-white
                        rounded-md
                        px-2
                        py-1
                        text-1-xl
                      "
                      v-on:click="submitRequest"
                    >
                      Submit
                    </button>
                    <p v-if="error" class="p-2 text-red-500 text-xs italic">
                      Les identifiants ne sont pas correct
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped></style>

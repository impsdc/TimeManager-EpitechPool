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
  data() {
    return {
      active: true,
      navigation,
    };
  },
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
  <div class="h-screen hidden lg:block shadow-lg relative w-80">
    <div class="bg-white h-full dark:bg-gray-700">
      <div class="flex items-center justify-start pt-6">
        <div class="flex space-2 items-center pb-4">
          <div>
            <svg
              class="h-10 w-10 text-purple-600 ml-3"
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
          </div>
          <div class="ml-3">
            <span>
              <h1 class="text-3xl font-bold text-purple-600 uppercase">
                {{ user.username }}
              </h1>
              <p class="text-left text-sm text-purple-600">
                {{ user.roleTitle }} - {{ user.id }}
              </p>
            </span>
          </div>
        </div>
      </div>

      <div class="trait"><hr /></div>

      <nav class="mt-6">
        <div>
          <div v-for="item of navigation" :key="item.name">
            <router-link
              v-if="item.access.includes(user.role)"
              :to="item.href"
              class="
                w-full
                font-thin
                uppercase
                text-gray-500
                dark:text-gray-200
                flex
                items-center
                p-4
                my-2
                transition-colors
                duration-200
                justify-start
                hover:text-purple-500
                active:text-purple-500
              "
            >
              <span v-html="item.svg"></span>
              <span class="mx-2 text-sm font-normal">
                {{ item.name }}
              </span>
            </router-link>
          </div>

          <div class="absolute bottom-0 left-0">
            <a
              class="
                w-full
                font-thin
                uppercase
                text-red-500
                dark:text-red-200
                flex
                items-center
                p-4
                my-2
                transition-colors
                duration-200
                justify-start
                hover:text-red-500
				cursor-pointer
              "
              v-on:click="logoutFuntion"
            >
              <span class="text-left">
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"
                  />
                </svg>
              </span>
              <span class="mx-2 text-sm font-normal"> Log out </span>
            </a>
          </div>
        </div>
      </nav>
    </div>
  </div>
</template>

<style scoped>
.router-link-exact-active {
  @apply bg-gradient-to-r from-white to-purple-100 border-r-4 border-purple-500 dark:from-gray-700 dark:to-gray-800 text-purple-500 !important;
}
</style>

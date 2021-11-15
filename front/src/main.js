import { createApp } from "vue";
import App from "./App.vue";
import router from "./router";
import "./index.css";
// import i18n from "./i18n";
// import "semantic-ui-css/semantic.css";

createApp(App).use(router).mount("#app");

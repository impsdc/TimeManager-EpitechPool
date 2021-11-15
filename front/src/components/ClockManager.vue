<script>
import axios from "axios";
import { onMounted, watch } from "@vue/runtime-core";
import { ref, computed } from "vue";
import useNotificationFactory from "@/tools/Toast";

export default {
  name: "ClockManager",
  props: {
    id: {
      type: Number,
    },
  },
  setup(props) {
    const notificationWarning = useNotificationFactory(
      "info",
      "Votre pointeuse est arrétée"
    );

    const notificationSuccess = useNotificationFactory(
      "Info",
      "Votre pointeuse est lancée !"
    );

    const notificationSuccessCreate = useNotificationFactory(
      "success",
      "Un temps de travail a été bien créé"
    );

    const clockIn = ref("");
    const startDateTime = ref("");
    const clockId = ref("");

    const hours = ref("");
    const minutes = ref("");
    const seconds = ref("");

    const clock = computed(
      () =>
        `${hours.value || "0"}h | ${minutes.value || "0"}m | ${
          seconds.value || "0"
        }s`
    );

    const getRealTime = () => {
      const currentTime = new Date();
      currentTime.setTime(
        currentTime.getTime() - new Date().getTimezoneOffset() * 60 * 1000
      );
      const realTime = currentTime
        .toISOString()
        .replace(/T/, " ")
        .replace(/\..+/, "");
      console.log(realTime);
      return realTime;
    };

    watch(clockIn, () => {
      handleClock();
    });

    const handleClick = () => {
      if (clockIn.value) {
        createWorkingtime();
        axios
          .put(
            `${process.env.VUE_APP_API_URL}clocks/${clockId.value}`,
            { time: null, status: false },
            { withCredentials: true }
          )
          .then((response) => {
            clockIn.value = false;
            notificationWarning();
          });
      } else {
        const time = getRealTime()
        axios
          .put(
            `${process.env.VUE_APP_API_URL}clocks/${clockId.value}`,
            {
              time: time,
              status: true,
            },
            { withCredentials: true }
          )
          .then((response) => {
            console.log(response)
            clockIn.value = true;
            startDateTime.value = time
          });
      }
    };
    const createWorkingtime = () => {
      axios
        .get(`${process.env.VUE_APP_API_URL}clocks/${props.id}`, {
          withCredentials: true,
        })
        .then((response) => {
          let startTime = response.data.data[0].time;
          axios
            .post(
              `${process.env.VUE_APP_API_URL}workingtimes`,
              {
                start: startDateTime.value,
                end: getRealTime(),
                user_id: props.id,
              },
              { withCredentials: true }
            )
            .then((response) => {
              setTimeout(() => {
                notificationSuccessCreate();
              }, 500);
            });
        });
    };

    const updateClock = () => {
      const time = new Date();
      const startTimeInteger = new Date(startDateTime.value);
      let delta = Math.abs(time - startTimeInteger);

      seconds.value = Math.ceil((delta / 1000) % 60);
      minutes.value = Math.floor((delta / 1000 / 60) % 60);
      hours.value = Math.abs(Math.ceil(delta / 1000 / 60 / 60 - (1 % 24)));
      handleClock();
    };

    const handleClock = () => {
      if (clockIn.value) {
        console.log("in")
        setTimeout(() => {
          updateClock();
        }, 1000);
      } else {
        seconds.value = 0;
        minutes.value = 0;
        hours.value = 0;
      }
    };

    onMounted( () => {
      axios
        .get(`${process.env.VUE_APP_API_URL}clocks/${props.id}`, {
          withCredentials: true,
        })
        .then((response) => {
          startDateTime.value = response.data.data[0].time;
          clockIn.value = response.data.data[0].status;
          clockId.value = response.data.data[0].id;
        });
    });

    return {
      clockIn,
      startDateTime,
      handleClick,
      createWorkingtime,
      notificationWarning,
      notificationSuccess,
      clock,
    };
  },
};
</script>

<template>
  <div class="text-center">
    <div class="p-5 text-lg">
      {{ clock }}
    </div>
    <button
      @click="handleClick"
      :class="[
        clockIn
          ? 'bg-yellow-500 hover:bg-yellow-700'
          : 'bg-purple-500 hover:bg-purple-700',
      ]"
      class="text-white font-bold py-2 px-4 rounded"
    >
      <span v-if="clockIn"> Arreter la pointeuse </span>
      <span v-else> Commencer la pointeuse </span>
    </button>
    <p class="text-gray-600 pt-5">
      Ci-dessus votre pointeuse, veuillez l'activer
      <strong>dès votre arrivée au bureau</strong> et la désactiver quand vous
      partez en<strong> pause dejeuner/café.</strong>
    </p>
  </div>
</template>

<style></style>
